import 'dart:async';

abstract class Middleware {
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request);
}

class AuthMiddleware implements Middleware {
  final bool required;
  final List<String> roles;

  AuthMiddleware({this.required = false, this.roles = const []});

  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    final headers = request['headers'] as Map<String, String>? ?? {};
    final authHeader = headers['Authorization'];

    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      if (required) {
        throw Exception('Authentication required');
      }
      return request;
    }

    final token = authHeader.substring(7);
    request['token'] = token;
    return request;
  }
}

class CorsMiddleware implements Middleware {
  final List<String> allowedOrigins;
  final List<String> allowedMethods;
  final List<String> allowedHeaders;

  CorsMiddleware({
    this.allowedOrigins = const ['*'],
    this.allowedMethods = const ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    this.allowedHeaders = const ['Content-Type', 'Authorization', 'X-Requested-With'],
  });

  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    final origin = request['origin'] as String? ?? '*';
    if (allowedOrigins.contains('*') || allowedOrigins.contains(origin)) {
      request['cors'] = {
        'Access-Control-Allow-Origin': origin,
        'Access-Control-Allow-Methods': allowedMethods.join(', '),
        'Access-Control-Allow-Headers': allowedHeaders.join(', '),
      };
    }
    return request;
  }
}

class LoggingMiddleware implements Middleware {
  final bool enabled;

  LoggingMiddleware({this.enabled = true});

  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    if (!enabled) return request;
    final method = request['method'] ?? 'GET';
    final path = request['path'] ?? '/';
    print('[${DateTime.now().toIso8601String()}] $method $path');
    return request;
  }
}

class RateLimitMiddleware implements Middleware {
  final int maxRequests;
  final Duration window;
  final Map<String, List<DateTime>> _requests = {};

  RateLimitMiddleware({this.maxRequests = 100, this.window = const Duration(minutes: 1)});

  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    final ip = request['ip'] as String? ?? 'unknown';
    final now = DateTime.now();

    _requests.putIfAbsent(ip, () => []);
    _requests[ip]!.removeWhere((t) => now.difference(t) > window);

    if (_requests[ip]!.length >= maxRequests) {
      throw Exception('Rate limit exceeded');
    }

    _requests[ip]!.add(now);
    request['rateLimit'] = {
      'limit': maxRequests,
      'remaining': maxRequests - _requests[ip]!.length,
    };
    return request;
  }
}

class ErrorMiddleware implements Middleware {
  final bool debug;

  ErrorMiddleware({this.debug = false});

  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    try {
      return request;
    } catch (e) {
      return {
        'statusCode': 500,
        'body': {'error': e.toString()},
      };
    }
  }
}

class CompressionMiddleware implements Middleware {
  final int minLength;

  CompressionMiddleware({this.minLength = 1024});

  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    request['compress'] = true;
    return request;
  }
}

class SecurityMiddleware implements Middleware {
  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    request['security'] = {
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'X-XSS-Protection': '1; mode=block',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
    };
    return request;
  }
}

class RequestIdMiddleware implements Middleware {
  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    request['requestId'] = _generateId();
    return request;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class TimingMiddleware implements Middleware {
  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    request['startTime'] = DateTime.now();
    return request;
  }
}

class BodyParserMiddleware implements Middleware {
  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    final body = request['body'];
    if (body is String) {
      try {
        request['parsedBody'] = Map<String, dynamic>.from(
          _parseJson(body),
        );
      } catch (_) {}
    }
    return request;
  }

  dynamic _parseJson(String body) {
    return body;
  }
}

class ValidationMiddleware implements Middleware {
  final Map<String, List<String Function(dynamic)>> rules;

  ValidationMiddleware({required this.rules});

  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    final body = request['parsedBody'] as Map<String, dynamic>? ?? {};
    final errors = <String, List<String>>{};

    for (final entry in rules.entries) {
      final field = entry.key;
      final validators = entry.value;
      final value = body[field];

      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          errors.putIfAbsent(field, () => []).add(error);
        }
      }
    }

    if (errors.isNotEmpty) {
      throw ValidationException('Validation failed', errors: errors);
    }

    return request;
  }
}

class CacheMiddleware implements Middleware {
  final Duration ttl;
  final Map<String, _CacheEntry> _cache = {};

  CacheMiddleware({this.ttl = const Duration(minutes: 5)});

  @override
  Future<Map<String, dynamic>> handle(Map<String, dynamic> request) async {
    final key = '${request['method']}:${request['path']}';
    final cached = _cache[key];
    if (cached != null && cached.isValid) {
      request['cached'] = cached.data;
    }
    return request;
  }

  void set(String key, dynamic data) {
    _cache[key] = _CacheEntry(data: data, createdAt: DateTime.now(), ttl: ttl);
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime createdAt;
  final Duration ttl;

  _CacheEntry({required this.data, required this.createdAt, required this.ttl});

  bool get isValid => DateTime.now().difference(createdAt) < ttl;
}

class MiddlewarePipeline {
  final List<Middleware> _middlewares = [];

  void add(Middleware middleware) {
    _middlewares.add(middleware);
  }

  Future<Map<String, dynamic>> execute(Map<String, dynamic> request) async {
    var result = request;
    for (final middleware in _middlewares) {
      result = await middleware.handle(result);
    }
    return result;
  }

  void clear() => _middlewares.clear();
}

class MiddlewareRegistry {
  final Map<String, Middleware> _middlewares = {};

  void register(String name, Middleware middleware) {
    _middlewares[name] = middleware;
  }

  Middleware? get(String name) => _middlewares[name];

  void remove(String name) => _middlewares.remove(name);

  void clear() => _middlewares.clear();
}

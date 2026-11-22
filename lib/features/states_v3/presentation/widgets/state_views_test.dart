import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/states_v3/presentation/widgets/state_views.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('loading state shows spinner', (tester) async {
    await tester.pumpWidget(_wrap(const StateViewV3(kind: StateKindV3.loading, title: 'Loading')));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('error state shows retry', (tester) async {
    var retried = false;
    await tester.pumpWidget(_wrap(StateViewV3(kind: StateKindV3.error, title: 'Error', message: 'Failed', actionLabel: 'Retry', onAction: () => retried = true)));
    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });

  testWidgets('async boundary renders data', (tester) async {
    await tester.pumpWidget(_wrap(AsyncBoundaryV3<String>(
      loading: false,
      data: 'Hello',
      builder: (data) => Text(data),
      loadingLabel: 'Loading',
      errorTitle: 'Error',
      retryLabel: 'Retry',
    )));
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('async boundary shows error', (tester) async {
    await tester.pumpWidget(_wrap(AsyncBoundaryV3<String>(
      loading: false,
      error: 'Network error',
      builder: (data) => Text(data),
      loadingLabel: 'Loading',
      errorTitle: 'Something went wrong',
      retryLabel: 'Retry',
    )));
    expect(find.text('Something went wrong'), findsOneWidget);
  });
}

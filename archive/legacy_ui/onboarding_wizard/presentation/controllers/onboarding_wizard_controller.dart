import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_gradients.dart';
import '../domain/onboarding_models.dart';

class OnboardingWizardController extends ChangeNotifier {
  OnboardingProfile _profile = const OnboardingProfile(
    name: '',
    email: '',
    avatar: 'U1',
    selectedSkills: [],
    goal: '',
    dailyMinutes: 0,
    notificationsEnabled: false,
    termsAccepted: false,
  );

  int _currentStep = 0;
  final int _totalSteps = 7;
  final PageController _pageController = PageController();
  bool _isLoading = false;
  Map<String, List<String>> _skillSelections = {};
  String _selectedGoal = '';
  int _selectedMinutes = 0;
  bool _notificationsEnabled = false;
  bool _termsAccepted = false;
  String _name = '';
  String _email = '';
  String _selectedAvatar = 'U1';

  OnboardingProfile get profile => _profile;
  int get currentStep => _currentStep;
  int get totalSteps => _totalSteps;
  PageController get pageController => _pageController;
  bool get isLoading => _isLoading;
  Map<String, List<String>> get skillSelections => _skillSelections;
  String get selectedGoal => _selectedGoal;
  int get selectedMinutes => _selectedMinutes;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get termsAccepted => _termsAccepted;
  String get name => _name;
  String get email => _email;
  String get selectedAvatar => _selectedAvatar;

  bool get canGoNext {
    switch (_currentStep) {
      case 0:
        return true;
      case 1:
        return _name.isNotEmpty && _email.isNotEmpty && _email.contains('@');
      case 2:
        return _skillSelections.isNotEmpty &&
            _skillSelections.values.any((s) => s.isNotEmpty);
      case 3:
        return _selectedGoal.isNotEmpty && _selectedMinutes > 0;
      case 4:
        return true;
      case 5:
        return _termsAccepted;
      case 6:
        return true;
      default:
        return false;
    }
  }

  bool get canGoPrevious => _currentStep > 0;

  double get progress => (_currentStep + 1) / _totalSteps;

  List<String> get availableAvatars => [
    'U1', 'U2', 'U3', 'U4', 'U5', 'U6', 'U7', 'U8',
    'U9', 'U10', 'U11', 'U12',
  ];

  List<Map<String, dynamic>> get skillCategories => [
    {
      'id': 'flutter',
      'title': 'Flutter',
      'subtitle': 'Cross-platform mobile apps',
      'icon': Icons.phone_android_rounded,
      'color': AppColors.primaryBlue,
      'options': [
        'Flutter Basics',
        'Widgets Deep Dive',
        'State Management',
        'Navigation & Routing',
        'Animations',
        'Firebase Integration',
        'Deployment',
      ],
    },
    {
      'id': 'python',
      'title': 'Python',
      'subtitle': 'Data science & automation',
      'icon': Icons.code_rounded,
      'color': AppColors.primaryYellow,
      'options': [
        'Python Basics',
        'Data Structures',
        'Web Scraping',
        'Automation Scripts',
        'Data Analysis',
        'Machine Learning',
        'Django Web',
      ],
    },
    {
      'id': 'webdev',
      'title': 'Web Development',
      'subtitle': 'HTML, CSS, JavaScript',
      'icon': Icons.language_rounded,
      'color': AppColors.primaryPurple,
      'options': [
        'HTML5',
        'CSS3',
        'JavaScript ES6+',
        'React',
        'Vue.js',
        'Node.js',
        'TypeScript',
      ],
    },
    {
      'id': 'security',
      'title': 'Cybersecurity',
      'subtitle': 'Ethical hacking & defense',
      'icon': Icons.security_rounded,
      'color': AppColors.primaryGreen,
      'options': [
        'Network Security',
        'Web Vulnerabilities',
        'Cryptography',
        'Penetration Testing',
        'Incident Response',
        'Security Compliance',
      ],
    },
    {
      'id': 'aiml',
      'title': 'AI / ML',
      'subtitle': 'Neural networks & models',
      'icon': Icons.psychology_rounded,
      'color': AppColors.primaryCyan,
      'options': [
        'Python for AI',
        'Machine Learning Basics',
        'Deep Learning',
        'Natural Language Processing',
        'Computer Vision',
        'Model Deployment',
      ],
    },
    {
      'id': 'gamedev',
      'title': 'Game Development',
      'subtitle': 'Unity & Unreal Engine',
      'icon': Icons.games_rounded,
      'color': AppColors.primaryOrange,
      'options': [
        'Unity Basics',
        'C# Programming',
        '2D Game Design',
        '3D Game Design',
        'Game Physics',
        'Multiplayer Networking',
      ],
    },
  ];

  List<Map<String, dynamic>> get goalOptions => [
    {
      'id': 'casual',
      'title': 'Casual Learner',
      'subtitle': '5 minutes per day',
      'minutes': 5,
      'icon': Icons.spa_rounded,
      'color': AppColors.primaryGreen,
    },
    {
      'id': 'regular',
      'title': 'Regular Learner',
      'subtitle': '15 minutes per day',
      'minutes': 15,
      'icon': Icons.school_rounded,
      'color': AppColors.primaryBlue,
    },
    {
      'id': 'serious',
      'title': 'Serious Learner',
      'subtitle': '30 minutes per day',
      'minutes': 30,
      'icon': Icons.fitness_center_rounded,
      'color': AppColors.primaryOrange,
    },
    {
      'id': 'hardcore',
      'title': 'Hardcore Learner',
      'subtitle': '60 minutes per day',
      'minutes': 60,
      'icon': Icons.local_fire_department_rounded,
      'color': AppColors.primaryPurple,
    },
  ];

  void setName(String value) {
    _name = value;
    _profile = _profile.copyWith(name: value);
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _profile = _profile.copyWith(email: value);
    notifyListeners();
  }

  void selectAvatar(String avatarId) {
    _selectedAvatar = avatarId;
    _profile = _profile.copyWith(avatar: avatarId);
    notifyListeners();
  }

  void toggleSkill(String categoryId, String skillId) {
    final selections = List<String>.from(
      _skillSelections[categoryId] ?? [],
    );
    if (selections.contains(skillId)) {
      selections.remove(skillId);
    } else {
      selections.add(skillId);
    }
    _skillSelections[categoryId] = selections;
    _profile = _profile.copyWith(
      selectedSkills: _skillSelections.values.expand((s) => s).toList(),
    );
    notifyListeners();
  }

  bool isSkillSelected(String categoryId, String skillId) {
    return _skillSelections[categoryId]?.contains(skillId) ?? false;
  }

  void selectGoal(String goalId, int minutes) {
    _selectedGoal = goalId;
    _selectedMinutes = minutes;
    _profile = _profile.copyWith(goal: goalId, dailyMinutes: minutes);
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    _profile = _profile.copyWith(notificationsEnabled: value);
    notifyListeners();
  }

  void toggleTerms(bool value) {
    _termsAccepted = value;
    _profile = _profile.copyWith(termsAccepted: value);
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < _totalSteps - 1 && canGoNext) {
      _currentStep++;
      _pageController.animateToPage(
        _currentStep,
        duration: AppMotion.smooth,
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _pageController.animateToPage(
        _currentStep,
        duration: AppMotion.smooth,
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < _totalSteps) {
      _currentStep = step;
      _pageController.animateToPage(
        step,
        duration: AppMotion.smooth,
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void reset() {
    _profile = const OnboardingProfile(
      name: '',
      email: '',
      avatar: 'U1',
      selectedSkills: [],
      goal: '',
      dailyMinutes: 0,
      notificationsEnabled: false,
      termsAccepted: false,
    );
    _currentStep = 0;
    _skillSelections = {};
    _selectedGoal = '';
    _selectedMinutes = 0;
    _notificationsEnabled = false;
    _termsAccepted = false;
    _name = '';
    _email = '';
    _selectedAvatar = 'U1';
    _pageController.jumpToPage(0);
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

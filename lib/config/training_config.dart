// Training Configuration - Easily customize all training content here
class TrainingConfig {
  // App Configuration
  static const String appName = 'BlitzNow Training';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const int primaryColor = 0xFF1E3A8A;
  static const int secondaryColor = 0xFF3B82F6;
  static const int accentColor = 0xFF10B981;
  
  // Joining Bonus Configuration
  static const double day1Bonus = 500.0;
  static const double day2Bonus = 500.0;
  static const double day3Bonus = 500.0;
  static const double totalBonus = day1Bonus + day2Bonus + day3Bonus;
  
  // Training Duration (in minutes)
  static const int day1Duration = 45;
  static const int day2Duration = 60;
  static const int day3Duration = 75;
  
  // Module Types
  static const List<String> moduleTypes = ['lm_hub', 'quick_hub'];
  
  // Day Types
  static const List<String> dayTypes = ['day1', 'day2', 'day3'];
  
  // Attendance Configuration
  static const int attendanceScanDuration = 3; // seconds
  static const bool requireFaceScan = true;
  
  // API Configuration
  static const String apiBaseUrl = 'YOUR_LAMBDA_API_ENDPOINT';
  static const int apiTimeout = 30000; // milliseconds
  
  // Google Sheets Configuration
  static const String progressSheetName = 'Training_Progress';
  static const List<String> sheetColumns = [
    'rider_id',
    'module_started_day1',
    'module_started_day2', 
    'module_started_day3',
    'module_completed_day1',
    'module_completed_day2',
    'module_completed_day3',
    'updated_at'
  ];
  
  // Training Content - Easy to customize
  static const Map<String, Map<String, String>> trainingContent = {
    'lm_hub': {
      'day1_title': 'Welcome to BlitzNow Family',
      'day1_subtitle': 'Day 1 Training - LM Hub',
      'day1_welcome': 'Welcome to BlitzNow Family! 🚀\nYou are now a Kaptaan (Captain) in our delivery network.',
      'day1_benefits': 'Being your own boss means:\n• Flexible working hours\n• Unlimited earning potential\n• Complete control over your schedule\n• Financial independence',
      'day1_commitment': 'BlitzNow is committed to empowering you with:\n• Competitive earnings per delivery\n• Joining bonus for completing training\n• Support and guidance throughout your journey\n• Tools and technology to succeed',
      
      'day2_title': 'Advanced Delivery Skills',
      'day2_subtitle': 'Day 2 Training - LM Hub',
      'day2_content': 'Today you will learn:\n• Earnings module and calculations\n• COD (Cash on Delivery) management\n• Best practices for daily operations\n• Customer service excellence',
      'day2_reminders': 'Important Reminders:\n• Mark attendance daily\n• Clear COD pendency by end of day\n• Maintain professional appearance\n• Follow safety guidelines',
      
      'day3_title': 'Master Delivery Partner',
      'day3_subtitle': 'Day 3 Training - LM Hub',
      'day3_content': 'Congratulations! You are almost ready!\n\nToday you will learn:\n• On-demand order access\n• How to receive extra orders\n• Referral program benefits\n• Advanced delivery techniques',
      'day3_final': 'Final Steps:\n• Complete all training modules\n• Receive your rider bag and t-shirt\n• Start earning with real orders\n• Build your delivery empire!',
    },
    
    'quick_hub': {
      'day1_title': 'Welcome to BlitzNow Family',
      'day1_subtitle': 'Day 1 Training - Quick Hub',
      'day1_welcome': 'Welcome to BlitzNow Family! 🚀\nYou are now a Kaptaan (Captain) in our delivery network.',
      'day1_benefits': 'Being your own boss means:\n• Flexible working hours\n• Unlimited earning potential\n• Complete control over your schedule\n• Financial independence',
      'day1_commitment': 'BlitzNow is committed to empowering you with:\n• Competitive earnings per delivery\n• Joining bonus for completing training\n• Support and guidance throughout your journey\n• Tools and technology to succeed',
      
      'day2_title': 'Advanced Delivery Skills',
      'day2_subtitle': 'Day 2 Training - Quick Hub',
      'day2_content': 'Today you will learn:\n• Earnings module and calculations\n• COD (Cash on Delivery) management\n• Best practices for daily operations\n• Customer service excellence',
      'day2_reminders': 'Important Reminders:\n• Mark attendance daily\n• Clear COD pendency by end of day\n• Maintain professional appearance\n• Follow safety guidelines',
      
      'day3_title': 'Master Delivery Partner',
      'day3_subtitle': 'Day 3 Training - Quick Hub',
      'day3_content': 'Congratulations! You are almost ready!\n\nToday you will learn:\n• On-demand order access\n• How to receive extra orders\n• Referral program benefits\n• Advanced delivery techniques',
      'day3_final': 'Final Steps:\n• Complete all training modules\n• Receive your rider bag and t-shirt\n• Start earning with real orders\n• Build your delivery empire!',
    },
  };
  
  // Task Lists - Easy to customize
  static const Map<String, Map<String, List<String>>> trainingTasks = {
    'lm_hub': {
      'day1': [
        'Mark attendance via face scan',
        'Complete guided delivery simulations',
        'Learn app navigation',
        'Understand delivery process',
        'Complete test orders',
      ],
      'day2': [
        'Complete attendance check',
        'Review earnings module',
        'Learn COD management',
        'Practice customer interactions',
        'Complete day 2 delivery tasks',
      ],
      'day3': [
        'Complete final training',
        'Learn on-demand features',
        'Understand referral program',
        'Final assessment',
        'Receive completion certificate',
      ],
    },
    
    'quick_hub': {
      'day1': [
        'Mark attendance via face scan',
        'Complete guided delivery simulations',
        'Learn app navigation',
        'Understand delivery process',
        'Complete test orders',
      ],
      'day2': [
        'Complete attendance check',
        'Review earnings module',
        'Learn COD management',
        'Practice customer interactions',
        'Complete day 2 delivery tasks',
      ],
      'day3': [
        'Complete final training',
        'Learn on-demand features',
        'Understand referral program',
        'Final assessment',
        'Receive completion certificate',
      ],
    },
  };
  
  // Messages and Notifications
  static const Map<String, String> messages = {
    'welcome': 'Welcome to BlitzNow Family! 🚀',
    'rider_not_found': 'Rider not found. Please check the Rider ID.',
    'training_started': 'Training started successfully!',
    'training_completed': 'Training completed successfully!',
    'attendance_marked': 'Attendance marked successfully!',
    'error_fetching_rider': 'Error fetching rider information',
    'error_starting_module': 'Error starting module',
    'error_completing_module': 'Error completing module',
  };
  
  // Validation Rules
  static const int minRiderIdLength = 3;
  static const int maxRiderIdLength = 20;
  static const String riderIdPattern = r'^[A-Za-z0-9_-]+$';
  
  // UI Configuration
  static const double cardElevation = 4.0;
  static const double buttonHeight = 50.0;
  static const double borderRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}

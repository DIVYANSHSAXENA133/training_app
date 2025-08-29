import '../models/training_module.dart';

class TrainingContentService {
  static List<TrainingModule> getTrainingModules() {
    return [
      // Day 1 - LM Hub
      TrainingModule(
        id: 'lm_hub_day1',
        title: 'Welcome to BlitzNow Family',
        description: 'Day 1 Training - LM Hub',
        moduleType: ModuleType.lmHub,
        dayType: DayType.day1,
        content: [
          'Welcome to BlitzNow Family! 🚀',
          'You are now a Kaptaan (Captain) in our delivery network.',
          'Being your own boss means:',
          '• Flexible working hours',
          '• Unlimited earning potential',
          '• Complete control over your schedule',
          '• Financial independence',
          '',
          'BlitzNow is committed to empowering you with:',
          '• Competitive earnings per delivery',
          '• Joining bonus for completing training',
          '• Support and guidance throughout your journey',
          '• Tools and technology to succeed',
        ],
        tasks: [
          'Mark attendance via face scan',
          'Complete guided delivery simulations',
          'Learn app navigation',
          'Understand delivery process',
          'Complete test orders',
        ],
        joiningBonus: 500.0,
      ),

      // Day 1 - Quick Hub
      TrainingModule(
        id: 'quick_hub_day1',
        title: 'Welcome to BlitzNow Family',
        description: 'Day 1 Training - Quick Hub',
        moduleType: ModuleType.quickHub,
        dayType: DayType.day1,
        content: [
          'Welcome to BlitzNow Family! 🚀',
          'You are now a Kaptaan (Captain) in our delivery network.',
          'Being your own boss means:',
          '• Flexible working hours',
          '• Unlimited earning potential',
          '• Complete control over your schedule',
          '• Financial independence',
          '',
          'BlitzNow is committed to empowering you with:',
          '• Competitive earnings per delivery',
          '• Joining bonus for completing training',
          '• Support and guidance throughout your journey',
          '• Tools and technology to succeed',
        ],
        tasks: [
          'Mark attendance via face scan',
          'Complete guided delivery simulations',
          'Learn app navigation',
          'Understand delivery process',
          'Complete test orders',
        ],
        joiningBonus: 500.0,
      ),

      // Day 2 - LM Hub
      TrainingModule(
        id: 'lm_hub_day2',
        title: 'Advanced Delivery Skills',
        description: 'Day 2 Training - LM Hub',
        moduleType: ModuleType.lmHub,
        dayType: DayType.day2,
        content: [
          'Day 2: Advanced Delivery Skills',
          '',
          'Today you will learn:',
          '• Earnings module and calculations',
          '• COD (Cash on Delivery) management',
          '• Best practices for daily operations',
          '• Customer service excellence',
          '',
          'Important Reminders:',
          '• Mark attendance daily',
          '• Clear COD pendency by end of day',
          '• Maintain professional appearance',
          '• Follow safety guidelines',
        ],
        tasks: [
          'Complete attendance check',
          'Review earnings module',
          'Learn COD management',
          'Practice customer interactions',
          'Complete day 2 delivery tasks',
        ],
        joiningBonus: 1000.0,
      ),

      // Day 2 - Quick Hub
      TrainingModule(
        id: 'quick_hub_day2',
        title: 'Advanced Delivery Skills',
        description: 'Day 2 Training - Quick Hub',
        moduleType: ModuleType.quickHub,
        dayType: DayType.day2,
        content: [
          'Day 2: Advanced Delivery Skills',
          '',
          'Today you will learn:',
          '• Earnings module and calculations',
          '• COD (Cash on Delivery) management',
          '• Best practices for daily operations',
          '• Customer service excellence',
          '',
          'Important Reminders:',
          '• Mark attendance daily',
          '• Clear COD pendency by end of day',
          '• Maintain professional appearance',
          '• Follow safety guidelines',
        ],
        tasks: [
          'Complete attendance check',
          'Review earnings module',
          'Learn COD management',
          'Practice customer interactions',
          'Complete day 2 delivery tasks',
        ],
        joiningBonus: 1000.0,
      ),

      // Day 3 - LM Hub
      TrainingModule(
        id: 'lm_hub_day3',
        title: 'Master Delivery Partner',
        description: 'Day 3 Training - LM Hub',
        moduleType: ModuleType.lmHub,
        dayType: DayType.day3,
        content: [
          'Day 3: Master Delivery Partner',
          '',
          'Congratulations! You are almost ready!',
          '',
          'Today you will learn:',
          '• On-demand order access',
          '• How to receive extra orders',
          '• Referral program benefits',
          '• Advanced delivery techniques',
          '',
          'Final Steps:',
          '• Complete all training modules',
          '• Receive your rider bag and t-shirt',
          '• Start earning with real orders',
          '• Build your delivery empire!',
        ],
        tasks: [
          'Complete final training',
          'Learn on-demand features',
          'Understand referral program',
          'Final assessment',
          'Receive completion certificate',
        ],
        joiningBonus: 1500.0,
      ),

      // Day 3 - Quick Hub
      TrainingModule(
        id: 'quick_hub_day3',
        title: 'Master Delivery Partner',
        description: 'Day 3 Training - Quick Hub',
        moduleType: ModuleType.quickHub,
        dayType: DayType.day3,
        content: [
          'Day 3: Master Delivery Partner',
          '',
          'Congratulations! You are almost ready!',
          '',
          'Today you will learn:',
          '• On-demand order access',
          '• How to receive extra orders',
          '• Referral program benefits',
          '• Advanced delivery techniques',
          '',
          'Final Steps:',
          '• Complete all training modules',
          '• Receive your rider bag and t-shirt',
          '• Start earning with real orders',
          '• Build your delivery empire!',
        ],
        tasks: [
          'Complete final training',
          'Learn on-demand features',
          'Understand referral program',
          'Final assessment',
          'Receive completion certificate',
        ],
        joiningBonus: 1500.0,
      ),
    ];
  }

  static TrainingModule? getModuleForRider(ModuleType moduleType, DayType dayType) {
    final modules = getTrainingModules();
    return modules.firstWhere(
      (module) => module.moduleType == moduleType && module.dayType == dayType,
      orElse: () => modules.first,
    );
  }

  static List<TrainingModule> getModulesForRider(ModuleType moduleType) {
    final modules = getTrainingModules();
    return modules.where((module) => module.moduleType == moduleType).toList();
  }
}

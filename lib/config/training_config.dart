// Training Configuration - Easily customize all training content here
class TrainingConfig {
  // Company Information
  static const Map<String, dynamic> company = {
    'name': 'BlitzNow',
    'tagline': 'Empowering Delivery Partners',
    'logo': '🚀',
  };

  // Day 1 Training Content - Different for each hub type
  static const Map<String, dynamic> day1 = {
    'title': 'Day 1 Training',
    'subtitle': 'Foundation & Basics',
    
    // LM Hub specific content
    'lm_hub': {
      'title': 'Day 1 Training - LM Hub',
      'subtitle': 'Last Mile Delivery Foundation',
      'steps': [
        {
          'id': 'welcome',
          'title': 'Welcome to LM Hub Training',
          'icon': '🏠',
          'content': {
            'title': 'Welcome to LM Hub - Last Mile Excellence!',
            'message': [
              'Dear Kaptaan, welcome to the LM Hub family!',
              'As an LM Hub delivery partner, you\'ll be the final link in our delivery chain, bringing packages directly to customers\' doorsteps.',
              'You\'ll learn specialized skills for residential deliveries, customer interactions, and managing complex delivery scenarios.',
              'Get ready to become a master of last-mile delivery excellence!'
            ]
          }
        },
        {
          'id': 'summary',
          'title': 'LM Hub Training Overview',
          'icon': '📚',
          'content': {
            'title': 'LM Hub Training Program Overview',
            'description': 'Complete daily tasks and residential delivery orders assigned by your team lead. Each day builds upon the previous one, preparing you for real-world last-mile delivery scenarios.',
            'specialFeatures': [
              'Residential delivery techniques',
              'Customer interaction protocols',
              'Complex address navigation',
              'Package handling best practices',
              'Customer satisfaction focus'
            ]
          }
        },
        {
          'id': 'attendance',
          'title': 'Attendance Marking',
          'icon': '📱',
          'content': {
            'title': 'Mark Your Attendance',
            'subtitle': 'Face Scan Required',
            'description': 'You must mark your attendance every day and be inside the LM Hub to receive residential delivery orders. This ensures proper tracking and order allocation.',
            'reminder': 'Attendance marking is mandatory for all training days. You cannot proceed with training or receive orders without marking attendance.',
            'lmHubSpecific': 'LM Hub partners must be present for morning briefings and route planning sessions.'
          }
        },
        {
          'id': 'lmHubTraining',
          'title': 'LM Hub Specific Training',
          'icon': '🏠',
          'content': {
            'title': 'Last Mile Delivery Training',
            'subtitle': 'Mastering Residential Deliveries',
            'description': 'Complete these specialized training modules to learn LM Hub specific skills:',
            'skills': [
              'Residential area navigation and route optimization',
              'Customer interaction and communication protocols',
              'Package handling for fragile and valuable items',
              'Address verification and delivery confirmation',
              'Customer feedback collection and satisfaction',
              'LM Hub app features and delivery management',
              'Safety protocols for residential deliveries',
              'Handling delivery challenges and exceptions'
            ],
            'lmHubFeatures': [
              'Advanced GPS navigation for residential areas',
              'Customer preference tracking',
              'Delivery time slot management',
              'Package photo confirmation system',
              'Customer rating and feedback system'
            ]
          }
        },
        {
          'id': 'ready',
          'title': 'Ready for LM Hub Delivery',
          'icon': '🎯',
          'content': {
            'title': 'Day 1 LM Hub Training Complete!',
            'message': 'Congratulations! You\'ve successfully completed Day 1 LM Hub training. You\'re now ready to handle residential delivery orders and start earning as a last-mile delivery specialist.',
            'progress': [
              {'label': 'Attendance', 'value': 'Marked'},
              {'label': 'LM Hub Training', 'value': 'Completed'},
              {'label': 'Residential Delivery Skills', 'value': 'Learned'},
              {'label': 'Hub Orientation', 'value': 'Completed'}
            ],
            'nextSteps': [
              'Start accepting residential delivery orders',
              'Apply learned navigation skills',
              'Focus on customer satisfaction',
              'Build your delivery reputation'
            ]
          }
        }
      ]
    },
    
    // Quick Hub specific content
    'quick_hub': {
      'title': 'Day 1 Training - Quick Hub',
      'subtitle': 'Express Delivery Foundation',
      'steps': [
        {
          'id': 'welcome',
          'title': 'Welcome to Quick Hub Training',
          'icon': '⚡',
          'content': {
            'title': 'Welcome to Quick Hub - Speed & Efficiency!',
            'message': [
              'Dear Kaptaan, welcome to the Quick Hub family!',
              'As a Quick Hub delivery partner, you\'ll be our speed champions, handling express deliveries and time-sensitive packages.',
              'You\'ll learn specialized skills for rapid deliveries, route optimization, and managing high-volume order scenarios.',
              'Get ready to become a master of express delivery excellence!'
            ]
          }
        },
        {
          'id': 'summary',
          'title': 'Quick Hub Training Overview',
          'icon': '📚',
          'content': {
            'title': 'Quick Hub Training Program Overview',
            'description': 'Complete daily tasks and express delivery orders assigned by your team lead. Each day builds upon the previous one, preparing you for real-world quick delivery scenarios.',
            'specialFeatures': [
              'Express delivery techniques',
              'Route optimization strategies',
              'High-volume order management',
              'Time-sensitive package handling',
              'Speed and efficiency focus'
            ]
          }
        },
        {
          'id': 'attendance',
          'title': 'Attendance Marking',
          'icon': '📱',
          'content': {
            'title': 'Mark Your Attendance',
            'subtitle': 'Face Scan Required',
            'description': 'You must mark your attendance every day and be inside the Quick Hub to receive express delivery orders. This ensures proper tracking and order allocation.',
            'reminder': 'Attendance marking is mandatory for all training days. You cannot proceed with training or receive orders without marking attendance.',
            'quickHubSpecific': 'Quick Hub partners must be present for speed training and route optimization sessions.'
          }
        },
        {
          'id': 'quickHubTraining',
          'title': 'Quick Hub Specific Training',
          'icon': '⚡',
          'content': {
            'title': 'Express Delivery Training',
            'subtitle': 'Mastering Speed & Efficiency',
            'description': 'Complete these specialized training modules to learn Quick Hub specific skills:',
            'skills': [
              'Express route planning and optimization',
              'High-volume order management techniques',
              'Time-sensitive package handling protocols',
              'Speed delivery app features and shortcuts',
              'Bulk order pickup and delivery strategies',
              'Quick Hub specific delivery zones',
              'Efficiency optimization techniques',
              'Handling urgent delivery requests'
            ],
            'quickHubFeatures': [
              'Real-time route optimization',
              'Bulk order management system',
              'Express delivery tracking',
              'Speed performance metrics',
              'Zone-based delivery optimization'
            ]
          }
        },
        {
          'id': 'ready',
          'title': 'Ready for Quick Hub Delivery',
          'icon': '🎯',
          'content': {
            'title': 'Day 1 Quick Hub Training Complete!',
            'message': 'Congratulations! You\'ve successfully completed Day 1 Quick Hub training. You\'re now ready to handle express delivery orders and start earning as a speed delivery specialist.',
            'progress': [
              {'label': 'Attendance', 'value': 'Marked'},
              {'label': 'Quick Hub Training', 'value': 'Completed'},
              {'label': 'Express Delivery Skills', 'value': 'Learned'},
              {'label': 'Hub Orientation', 'value': 'Completed'}
            ],
            'nextSteps': [
              'Start accepting express delivery orders',
              'Apply learned speed techniques',
              'Focus on delivery efficiency',
              'Build your speed reputation'
            ]
          }
        }
      ]
    }
  };

  // Joining Bonus Structure
  static const Map<String, dynamic> joiningBonus = {
    'totalAmount': 1500,
    'currency': '₹',
    'dailyAmount': 500,
    'note': 'Joining bonus is exclusive of your per-order earnings',
  };
}

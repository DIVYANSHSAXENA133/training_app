enum ModuleType { lmHub, quickHub }
enum DayType { day1, day2, day3 }

class TrainingModule {
  final String id;
  final String title;
  final String description;
  final ModuleType moduleType;
  final DayType dayType;
  final List<String> content;
  final List<String> tasks;
  final double joiningBonus;
  final bool isCompleted;

  TrainingModule({
    required this.id,
    required this.title,
    required this.description,
    required this.moduleType,
    required this.dayType,
    required this.content,
    required this.tasks,
    required this.joiningBonus,
    this.isCompleted = false,
  });

  factory TrainingModule.fromJson(Map<String, dynamic> json) {
    return TrainingModule(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      moduleType: ModuleType.values.firstWhere(
        (e) => e.toString() == 'ModuleType.${json['module_type']}',
        orElse: () => ModuleType.lmHub,
      ),
      dayType: DayType.values.firstWhere(
        (e) => e.toString() == 'DayType.${json['day_type']}',
        orElse: () => DayType.day1,
      ),
      content: List<String>.from(json['content'] ?? []),
      tasks: List<String>.from(json['tasks'] ?? []),
      joiningBonus: (json['joining_bonus'] ?? 0.0).toDouble(),
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'module_type': moduleType.toString().split('.').last,
      'day_type': dayType.toString().split('.').last,
      'content': content,
      'tasks': tasks,
      'joining_bonus': joiningBonus,
      'is_completed': isCompleted,
    };
  }
}

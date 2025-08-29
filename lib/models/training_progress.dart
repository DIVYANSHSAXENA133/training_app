class TrainingProgress {
  final String riderId;
  final Map<String, String> moduleStarted;
  final Map<String, String> moduleCompleted;
  final DateTime updatedAt;

  TrainingProgress({
    required this.riderId,
    required this.moduleStarted,
    required this.moduleCompleted,
    required this.updatedAt,
  });

  factory TrainingProgress.fromJson(Map<String, dynamic> json) {
    return TrainingProgress(
      riderId: json['rider_id'] ?? '',
      moduleStarted: Map<String, String>.from(json['module_started'] ?? {}),
      moduleCompleted: Map<String, String>.from(json['module_completed'] ?? {}),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rider_id': riderId,
      'module_started': moduleStarted,
      'module_completed': moduleCompleted,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TrainingProgress copyWith({
    String? riderId,
    Map<String, String>? moduleStarted,
    Map<String, String>? moduleCompleted,
    DateTime? updatedAt,
  }) {
    return TrainingProgress(
      riderId: riderId ?? this.riderId,
      moduleStarted: moduleStarted ?? this.moduleStarted,
      moduleCompleted: moduleCompleted ?? this.moduleCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

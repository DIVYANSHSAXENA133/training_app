class Tutorial {
  final String id;
  final String title;
  final String subtitle;
  final String? description;
  final bool isDone;

  Tutorial({
    required this.id,
    required this.title,
    required this.subtitle,
    this.description,
    required this.isDone,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'],
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'isDone': isDone,
    };
  }

  Tutorial copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    bool? isDone,
  }) {
    return Tutorial(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}

class TutorialState {
  final String id;
  final bool isDone;

  TutorialState({
    required this.id,
    required this.isDone,
  });

  factory TutorialState.fromJson(Map<String, dynamic> json) {
    return TutorialState(
      id: json['id'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isDone': isDone,
    };
  }
}

class GetTutorialsResponse {
  final String message;
  final GetTutorialsData? data;

  GetTutorialsResponse({
    required this.message,
    this.data,
  });

  factory GetTutorialsResponse.fromJson(Map<String, dynamic> json) {
    return GetTutorialsResponse(
      message: json['message'] ?? '',
      data: json['data'] != null ? GetTutorialsData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class GetTutorialsData {
  final int riderAge;
  final List<Tutorial> tutorials;

  GetTutorialsData({
    required this.riderAge,
    required this.tutorials,
  });

  factory GetTutorialsData.fromJson(Map<String, dynamic> json) {
    return GetTutorialsData(
      riderAge: json['rider_age'] ?? 0,
      tutorials: (json['tutorials'] as List<dynamic>?)
          ?.map((tutorial) => Tutorial.fromJson(tutorial))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rider_age': riderAge,
      'tutorials': tutorials.map((tutorial) => tutorial.toJson()).toList(),
    };
  }
}


class Rider {
  final String riderId;
  final String nodeType;
  final int? riderAge;

  Rider({
    required this.riderId,
    required this.nodeType,
    this.riderAge,
  });

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      riderId: json['rider_id'] ?? '',
      nodeType: json['node_type'] ?? '',
      riderAge: json['rider_age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rider_id': riderId,
      'node_type': nodeType,
      'rider_age': riderAge,
    };
  }
}

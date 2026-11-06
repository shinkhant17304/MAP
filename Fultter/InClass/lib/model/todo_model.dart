class TodoModel {
  final String id;
  final String title;
  final DateTime deadline;
  final bool complete;
  final bool favorite;

  TodoModel({
    required this.id,
    required this.title,
    required this.deadline,
    this.complete = false,
    this.favorite = false,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      deadline: _parseDate(json['deadline']),
      complete: json['complete'] == true,
      favorite: json['favorite'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline.toIso8601String(),
      'complete': complete,
      'favorite': favorite,
    };
  }

  TodoModel copyWith({
    String? id,
    String? title,
    DateTime? deadline,
    bool? complete,
    bool? favorite,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      complete: complete ?? this.complete,
      favorite: favorite ?? this.favorite,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}

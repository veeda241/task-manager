class Task {
  final int id;
  final String title;
  final String description;
  final bool is_completed;

  Task({required this.id, required this.title, required this.description, required this.is_completed});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      is_completed: json['is_completed'],
    );
  }
}

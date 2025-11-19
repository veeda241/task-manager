class TaskCreate {
  final String title;
  final String description;

  TaskCreate({required this.title, required this.description});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

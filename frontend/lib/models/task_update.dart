class TaskUpdate {
  final String? title;
  final String? description;
  final bool? is_completed;

  TaskUpdate({this.title, this.description, this.is_completed});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'is_completed': is_completed,
    };
  }
}

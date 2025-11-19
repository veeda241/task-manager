import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Checkbox(
                  value: task.is_completed,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      taskProvider.updateTask(
                        task.id,
                        task.title,
                        task.description,
                        newValue,
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _showEditTaskDialog(context, taskProvider),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () => _confirmDeleteTask(context, taskProvider),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskProvider taskProvider) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              taskProvider.updateTask(
                task.id,
                titleController.text,
                descriptionController.text,
                task.is_completed,
              );
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('This action will permanently delete the task.'),
        actions: [
          TextButton(child: const Text('No'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              taskProvider.deleteTask(task.id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}

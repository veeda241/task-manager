import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Tasks are now fetched by the TaskProvider when the auth state changes.
    // Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  void _showAddTaskDialog() {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).createTask(
                _titleController.text,
                _descriptionController.text,
              );
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authProvider.logout();
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (ctx, taskData, child) => taskData.tasks.isEmpty
            ? Center(child: Text('No tasks found.'))
            : ListView.builder(
                itemCount: taskData.tasks.length,
                itemBuilder: (ctx, i) => TaskCard(task: taskData.tasks[i]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddTaskDialog,
      ),
    );
  }
}
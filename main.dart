import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoApp());
}

class Task {
  String name;
  bool isCompleted;

  Task({required this.name, this.isCompleted = false});
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _textController = TextEditingController();

  void _addTask() {
    if (_textController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(Task(name: _textController.text.trim()));
        _textController.clear();
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _clearCompleted() {
    setState(() {
      int count = _tasks.where((t) => t.isCompleted).length;
      _tasks.removeWhere((task) => task.isCompleted);
      if (count > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cleared $count completed tasks')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int activeCount = _tasks.where((t) => !t.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'My Tasks',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        actions: [
          if (_tasks.any((t) => t.isCompleted))
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                onPressed: _clearCompleted,
                icon: const Icon(Icons.delete_sweep),
                label: const Text("Clear Done"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                ),
              ),
            )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'You have $activeCount active tasks',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        color: task.isCompleted ? Colors.grey[100] : Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          activeColor: Theme.of(context).colorScheme.primary,
                          checkColor: Colors.white,
                          title: Text(
                            task.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: task.isCompleted
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: task.isCompleted
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                          value: task.isCompleted,
                          onChanged: (_) => _toggleTask(index),
                          controlAffinity: ListTileControlAffinity.leading,
                          secondary: task.isCompleted
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.circle_outlined, color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Add a new task...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onSubmitted: (_) => _addTask(),
            ),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: _addTask,
            elevation: 2,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
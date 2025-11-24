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
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
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
    if (_textController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(name: _textController.text));
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
      _tasks.removeWhere((task) => task.isCompleted);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session To-Do List'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear Completed',
            onPressed: _clearCompleted,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Enter a new task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: _tasks.isEmpty
                ? const Center(
              child: Text(
                'No tasks yet. Add one above!',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return CheckboxListTile(
                  title: Text(
                    task.name,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  value: task.isCompleted,
                  onChanged: (bool? value) {
                    _toggleTask(index);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          ),

          if (_tasks.any((t) => t.isCompleted))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton.icon(
                onPressed: _clearCompleted,
                icon: const Icon(Icons.check),
                label: const Text("Clear Completed Tasks"),
              ),
            ),
        ],
      ),
    );
  }
}
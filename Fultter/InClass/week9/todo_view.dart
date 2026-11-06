import 'package:flutter/material.dart';
import 'package:inclass/model/todo_model.dart';
import 'package:inclass/views/todo_detail_view.dart';
import 'package:inclass/views/todo_edit_view.dart';

import 'todo_controller.dart';

class TodoView extends StatelessWidget {
  final TodoController? todoController;
  const TodoView({super.key, this.todoController});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        body: TodoApp(todoController: todoController),
      ),
    );
  }
}

class TodoApp extends StatefulWidget {
  final TodoController? todoController;
  const TodoApp({super.key, this.todoController});

  @override
  State<TodoApp> createState() => TodoAppState();
}

class TodoAppState extends State<TodoApp> {
  late TodoController todoController;
  late Future<List<TodoModel>> tasksFuture;
  final textController = TextEditingController();
  final searchController = TextEditingController();
  DateTime? dt;

  @override
  void initState() {
    super.initState();
    todoController = widget.todoController ?? TodoController();
    tasksFuture = todoController.fetchTasks();
  }

  void refreshTasks() {
    if (!mounted) return;
    setState(() {
      tasksFuture = todoController.fetchTasks();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> setDeadline() async {
    dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );
  }

  Future<void> addTodo() async {
    String newTodo = textController.text.trim();
    if (newTodo.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error: No input')));
      return;
    }
    await todoController.addTask(newTodo, dt ?? DateTime.now());
    if (!mounted) return;
    textController.clear();
    dt = null;
    refreshTasks();
  }

  Future<void> toggleFavorite(String id, bool status) async {
    await todoController.toggleFavorite(id, !status);
    refreshTasks();
  }

  Future<void> toggleComplete(String id, bool status) async {
    await todoController.toggleComplete(id, !status);
    refreshTasks();
  }

  void gotoDetailPage(TodoModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetailView(task: task)),
    );
  }

  void gotoEditPage(TodoModel task) async {
    String? title = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (context) => TodoEditView(task: task)),
    );
    if (!context.mounted) return;
    if (title == null) return;
    await todoController.updateTask(task.id, title);
    refreshTasks();
  }

  Widget buildAddUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New task',
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: setDeadline,
            icon: const Icon(Icons.calendar_today),
            label: const Text('Deadline'),
          ),
          const SizedBox(width: 4),
          FilledButton(onPressed: addTodo, child: const Text('Add')),
        ],
      ),
    );
  }

  Widget buildTodoUI() {
    return FutureBuilder<List<TodoModel>>(
      future: tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildListView(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // --- UPDATED BUILD LIST VIEW WITH TASK STATUS COUNTS ---
  Widget buildListView(List<TodoModel> data) {
    final filteredData = todoController.searchTasks(
      data,
      searchController.text,
    );
    final int all = todoController.countAll(filteredData);
    final int pending = todoController.countPending(filteredData);
    final int complete = todoController.countComplete(filteredData);
    final int favorite = todoController.countFavorite(filteredData);

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Search tasks',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                      ),
              ),
            ),
          ),
          // Status counts header line
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'All: $all, Pending: $pending, Complete: $complete, Favorite: $favorite',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            child: filteredData.isEmpty
                ? const Center(child: Text('No matching tasks'))
                : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final task = filteredData[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.star),
                            color: task.favorite ? Colors.amber : Colors.grey,
                            onPressed: () =>
                                toggleFavorite(task.id, task.favorite),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.complete
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.zoom_in),
                                onPressed: () => gotoDetailPage(task),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => gotoEditPage(task),
                              ),
                            ],
                          ),
                          onTap: () => toggleComplete(task.id, task.complete),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [buildAddUI(), buildTodoUI()]);
  }
}

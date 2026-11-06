

// todo_logic.dart
// Task model, repository, and service (controller) logic.
 
class Task {
  String title;
  bool complete;
 
  Task(this.title, {this.complete = false});
 
  @override
  String toString() {
    final status = complete ? 'Done' : 'Pending';
    return '$title [$status]';
  }
}
 
// ---------------- Repository ----------------
// Owns raw storage of tasks.
class TaskRepository {
  final List<Task> _tasks = [];
 
  List<Task> getAll() => _tasks;
 
  void add(Task task) => _tasks.add(task);
 
  Task? removeAt(int index) {
    if (index < 0 || index >= _tasks.length) return null;
    return _tasks.removeAt(index);
  }
 
  void clear() => _tasks.clear();
}
 
// ---------------- Service (controller) ----------------
// Business logic on top of the repository. The menu and tests
// both talk to this class.
class TaskService {
  final TaskRepository _repo;
 
  TaskService(this._repo);
 
  List<Task> get tasks => _repo.getAll();
 
  void addTask(String title) {
    _repo.add(Task(title));
  }
 
  Task? deleteTask(int index) {
    return _repo.removeAt(index);
  }
 
  bool toggleTask(int index) {
    final list = _repo.getAll();
    if (index < 0 || index >= list.length) return false;
    list[index].complete = !list[index].complete;
    return true;
  }
 
  // a) Edit task — based on task ID (index in this list-backed store)
  bool editTask(int id, String newTitle) {
    final list = _repo.getAll();
    if (id < 0 || id >= list.length) return false;
    if (newTitle.trim().isEmpty) return false;
    list[id].title = newTitle.trim();
    return true;
  }
 
  // b) Search tasks — by title, case-insensitive, can return multiple results
  List<Task> search(String keyword) {
    final query = keyword.trim().toLowerCase();
    if (query.isEmpty) return [];
    return _repo.getAll()
        .where((t) => t.title.toLowerCase().contains(query))
        .toList();
  }
 
  void clearAll() {
    _repo.clear();
  }
}
 
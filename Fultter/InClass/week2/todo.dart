import 'dart:io';

void main() {
  List<Map<String, dynamic>> tasks = [];

  while (true) {
    print("\n========== TODO app ==========");
    print("1. View Tasks");
    print("2. Add Task");
    print("3. Delete Task");
    print("4. Toggle Task Status");
    print("5. Clear All Tasks");
    print("6. Exit");
    print("=============================");

    stdout.write("Select an option (1-6): ");
    String? input = stdin.readLineSync();
    int? choice = int.tryParse(input ?? "");

    switch (choice) {
      case 1:
        // View Tasks
        print("--------- All Tasks --------");

        if (tasks.isEmpty) {
          print("No tasks");
        } else {
          for (int i = 0; i < tasks.length; i++) {
            String status = tasks[i]["done"] ? "[X]" : "[ ]";
            print("${i + 1}. $status ${tasks[i]["title"]}");
          }
        }
        break;

      case 2:
        // Add Task
        stdout.write("Enter task: ");
        String? task = stdin.readLineSync();

        if (task != null && task.isNotEmpty) {
          tasks.add({
            "title": task,
            "done": false,
          });
        }
        break;

      case 3:
        // Delete Task
        stdout.write("Enter task ID: ");
        int? id = int.tryParse(stdin.readLineSync() ?? "");

        if (id != null && id >= 1 && id <= tasks.length) {
          tasks.removeAt(id - 1);
          print("Success: task deleted");
        } else {
          print("Error: invalid task ID");
        }
        break;

      case 4:
        // Toggle Task Status
        stdout.write("Enter task ID: ");
        int? id = int.tryParse(stdin.readLineSync() ?? "");

        if (id != null && id >= 1 && id <= tasks.length) {
          tasks[id - 1]["done"] = !tasks[id - 1]["done"];
          print("Success: task toggled");
        } else {
          print("Error: invalid task ID");
        }
        break;

      case 5:
        // Clear All Tasks
        tasks.clear();
        print("Success: all tasks cleared");
        break;

      case 6:
        // Exit
        print("Goodbye!");
        return;

      default:
        print("Please choose an option from 1 to 6.");
    }
  }
}
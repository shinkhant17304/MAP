import 'dart:io';
import 'package:dart_application_1/logic.dart';
import 'package:dart_application_1/model.dart';



void main() async {
 // Ensure the app waits for async operations to initialize if necessary
 final connector = Connector();


 print('--- Welcome to the Dart TODO Console ---');


 String? input;
 while (input != '7') {
   showMenu();
   stdout.write('Select an option: ');
   input = stdin.readLineSync();


   switch (input) {
     case '1':
       await viewTasks(connector);
       break;
     case '7':
       print('Goodbye!');
     default:
       print('Invalid selection. Please try again.');
   }
 }
}


// show menu
void showMenu() {
 print('\n======== Menu ========');
 print('1. View Tasks');
 print('2. Add New Task');
 print('3. Delete Task');
 print('4. Toggle Task Status');
 print('5. Edit Task');
 print('6. Search Task');
 print('7. Exit');
}


Future<void> viewTasks(Connector api) async {
 try {
   List<dynamic> todos = await api.getTasks();
  
   if (todos.isEmpty) {
     print('\nNo tasks found.');
     return;
   }
   
   // loop to show all tasks
   print('-------------------');
   for (var (index, todo) in todos.indexed) {
     print('${index + 1}. $todo');
   }


   // count complete tasks and show the count
   


 } on Exception catch (e) {
   print('Error: $e');
 }
}


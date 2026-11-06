import 'dart:convert';
import 'package:dart_application_1/model.dart';
import 'package:http/http.dart' as http;


class Connector{
  // get tasks
  Future<void> addTasks(String title, bool completed) async {

    try {
      final header = {'content-Type': 'application/json'};
      final body = jsonEncode({"title": title, "completed": completed});

    http.Response response = await http.post(
      Uri.parse('http://localhost:3000/todo'),
      headers: header, // Pass your JSON content-type header
      body: body,      // Pass your JSON encoded body
      );
    // response = status code + body
    if (response.statusCode == 200) {
      throw Exception('Bad Response');


    } // ok
    catch (e){
      throw Exception('Error:'$e);
    }
      // correct response's body
      List data = jsonDecode(response.body);

      // data[0][titile]
      // TODO: convert data to List<Task>
      // send each list's member to the model and get the task in return
      // Task task1 = Task.fromJson(data[0]); // Task.fromJson(data[0]) => Task("1", "Cooking", false)
      // Task task2 = Task.fromJson(data[1]); 
      // Task task3 = Task.fromJson(data[2]); 


      // // Originally, we can have the list of map
      // // crate the list of task
      // List todos = [];
      // todos.add(task1.getTask());
      // todos.add(task2.getTask());
      // todos.add(task3.getTask());

      // List todos = [];
      // for (Map d in data) {
      //   Task task = Task.fromJson(d);
      //   todos.add(task);
      // }

      List<Task> todos = data.map((d) => Task.fromJson(d)).toList();


      return todos;
    }   
    catch (e) {
      throw Exception('Error: $e');
    }
  }
  //add new task

  // delete task

  // edit task

  // toggle task

  // 

}
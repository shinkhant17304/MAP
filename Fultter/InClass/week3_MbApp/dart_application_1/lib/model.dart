class Task {
  String id = '';
  String title = '';
  bool completed = false;

  // constructor
  // default constructor is only for give intial value to the object
  Task(this.id, this.title, this.completed);
  String getTask() {
    String status = completed ? '✅' : '⌛';
    return '$status $title';

  }
  
  // convert Task to JSON
  //task fromJSON(Map json)
  // return Task(json['id'] as String, json['title'] as String, json['completed'] as bool);

  // factory constructor: Task task = Task.fromJson(json);
  // factory constructor is to create the object with extra logic
  factory Task.fromJson(Map json) => Task (json['id'] as String, json['title'] as String, json['completed'] as bool);
  

}
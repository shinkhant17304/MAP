import 'package:dart_application_1/logic.dart'; 
import 'package:test/test.dart'; 

void main() { 
  
  test('1. Get task should return a task', () async { 
    Connector connector = Connector(); 
    List data = await connector.getTasks(); 
    
    expect(data.length, 3); 
    expect(data[0].id, "1"); 
    expect(data[0].title, "Cooking"); 
    expect(data[0].completed, false); 
  }); 
    test('2. add task should a new task', () async { 
    Connector connector = Connector(); 
    List data = await connector.addTasks("Go swimming", false); 
    List<Task> data = await connector.getTask
    
    
    expect(data.length, 5); 
    expect(data[0].id, "1"); 
    expect(data[0].title, "Cooking"); 
    expect(data[0].completed, false); 
  }); 
}

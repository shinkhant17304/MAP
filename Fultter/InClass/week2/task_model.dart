class Task {
 String title = '';
 bool complete = false;


 // constructor
 Task(this.title);


 // toggle status
 void toggleStatus() {
   complete = !complete;
 }


 // show task
 // String showTask() {
 //   String status = complete ? '[X]' : '[ ]';
 //   return "$status $title";
 // }


 // or override toString() so we can print the Object directly
 @override
 String toString() {
   String status = complete ? '[X]' : '[ ]';
   return " $status $title";
 }
}


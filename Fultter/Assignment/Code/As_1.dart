void main() {
  String id = "6731501157";
  int sum = 0;

  for (int i = 0; i < id.length; i++) {
    sum += int.parse(id[i]);
  }

  print("Sum of $id = $sum");
}
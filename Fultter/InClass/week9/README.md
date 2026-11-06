# Week 9 Todo App

Run these commands from the project root:

```sh
npx json-server db.json --port 3001
```

In a second terminal, start the app in Chrome:

```sh
flutter run -t week9/main.dart -d chrome \
  --dart-define=TODO_API_URL=http://localhost:3001/todo
```

Run the Week 9 controller tests without starting the API server:

```sh
flutter test week9/unit_test_todo.dart
```

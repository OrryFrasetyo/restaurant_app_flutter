enum MyWorkmanager {
  oneOff("task-identifier", "task-identifier"),
  periodic("com.example.restaurant_app",
      "com.example.restaurant_app");

  final String uniqueName;
  final String taskName;

  const MyWorkmanager(this.uniqueName, this.taskName);
}
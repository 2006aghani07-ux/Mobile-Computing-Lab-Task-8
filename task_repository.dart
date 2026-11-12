import 'task.dart';

abstract class TaskRepository {
  List<Task> getTasks();
  void addTask(Task task);
  void removeTask(String id);
  void insertTask(int index, Task task);
  void toggleTask(String id);
}

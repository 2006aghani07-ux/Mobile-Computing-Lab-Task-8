import '../domain/task.dart';
import '../domain/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: '1',
      title: 'Complete Flutter lab',
      description: 'Build the Campus Hub interface.',
    ),
    const Task(
      id: '2',
      title: 'Prepare project idea',
      description: 'Write a one-page app proposal.',
    ),
  ];

  @override
  List<Task> getTasks() => List.unmodifiable(_tasks);

  @override
  void addTask(Task task) {
    _tasks.add(task);
  }

  @override
  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
  }

  @override
  void insertTask(int index, Task task) {
    _tasks.insert(index.clamp(0, _tasks.length).toInt(), task);
  }

  @override
  void toggleTask(String id) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _tasks[i] = _tasks[i].copyWith(isDone: !_tasks[i].isDone);
  }
}

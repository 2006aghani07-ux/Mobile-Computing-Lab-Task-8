import 'package:flutter/material.dart';

import '../../../core/animations.dart';
import '../../../core/app_theme.dart';
import '../domain/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final Color accent;
  final VoidCallback onToggle;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onToggle,
    this.accent = AppColors.primary,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late bool _done = widget.task.isDone;

  void _toggle() {
    widget.onToggle();
    setState(() => _done = !_done);
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return Scaffold(
      appBar: AppBar(title: const Text('Task details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'task-${task.id}',
              child: CircleAvatar(
                radius: 34,
                backgroundColor: widget.accent,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    _done ? Icons.check_circle : Icons.check_circle_outline,
                    key: ValueKey(_done),
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            FadeSlideIn(
              delay: stagger(1),
              child: Text(
                task.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration:
                          _done ? TextDecoration.lineThrough : null,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            FadeSlideIn(delay: stagger(2), child: Text(task.description)),
            const SizedBox(height: 16),
            FadeSlideIn(
              delay: stagger(3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _done
                      ? AppColors.teal.withValues(alpha: 0.15)
                      : AppColors.coral.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _done ? Icons.done_all : Icons.hourglass_bottom,
                      size: 16,
                      color: _done ? AppColors.teal : AppColors.coral,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _done ? 'Completed' : 'In progress',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _done ? AppColors.teal : AppColors.coral,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FadeSlideIn(
              delay: stagger(4),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _toggle,
                  icon: Icon(_done ? Icons.undo : Icons.check),
                  label: Text(_done ? 'Mark as not done' : 'Mark as done'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeSlideIn(
              delay: stagger(5),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Home'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

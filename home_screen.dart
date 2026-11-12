import 'package:flutter/material.dart';

import '../../../core/animations.dart';
import '../../../core/app_theme.dart';
import '../../../core/campus_data.dart';
import '../../../core/place_card.dart';
import '../../explore/explore_screen.dart';
import '../../explore/place_detail_screen.dart';
import '../../profile/profile_screen.dart';
import '../../showcase/ui_showcase_screen.dart';
import '../../webview/web_view_screen.dart';
import '../data/in_memory_task_repository.dart';
import '../domain/task.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = InMemoryTaskRepository();
  int _selectedIndex = 0;

  static const _titles = ['Campus Hub', 'Explore', 'My Profile'];

  void _openTab(int index) {
    setState(() => _selectedIndex = index);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  /// Closes the drawer, then pushes [page] with the shared transition.
  void _openFromDrawer(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, fadeSlideRoute<void>(page));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      const ExploreScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.4),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: Text(
            _titles[_selectedIndex],
            key: ValueKey(_selectedIndex),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Add task',
            icon: const Icon(Icons.add_circle,
                color: AppColors.primary, size: 28),
            onPressed: _addTask,
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: _buildDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 380),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (current, previous) => Stack(
          fit: StackFit.expand,
          children: [...previous, if (current != null) current],
        ),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: pages[_selectedIndex],
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: _selectedIndex == 0
            ? FloatingActionButton.extended(
                key: const ValueKey('fab'),
                onPressed: _addTask,
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('New task'),
              )
            : const SizedBox.shrink(key: ValueKey('no-fab')),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Material(
            color: Colors.white,
            elevation: 3,
            shadowColor: AppColors.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(28),
            clipBehavior: Clip.antiAlias,
            child: NavigationBar(
              height: 64,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: 'Explore',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- drawer

  Widget _buildDrawer() {
    final topInset = MediaQuery.paddingOf(context).top;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, topInset + 28, 20, 20),
            decoration: const BoxDecoration(gradient: AppTheme.gradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: const CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.school_rounded,
                        size: 32, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Student User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'student@example.com',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          FadeSlideIn(
            delay: stagger(1, stepMs: 70),
            offset: const Offset(-0.2, 0),
            child: ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary),
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pop(context);
                _openTab(0);
              },
            ),
          ),
          FadeSlideIn(
            delay: stagger(2, stepMs: 70),
            offset: const Offset(-0.2, 0),
            child: ListTile(
              leading: const Icon(Icons.explore, color: AppColors.primary),
              title: const Text('Explore'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.pop(context);
                _openTab(1);
              },
            ),
          ),
          FadeSlideIn(
            delay: stagger(3, stepMs: 70),
            offset: const Offset(-0.2, 0),
            child: ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: const Text('Profile'),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.pop(context);
                _openTab(2);
              },
            ),
          ),
          const Divider(),
          FadeSlideIn(
            delay: stagger(4, stepMs: 70),
            offset: const Offset(-0.2, 0),
            child: ListTile(
              leading: const Icon(Icons.widgets_outlined,
                  color: AppColors.primary),
              title: const Text('UI Showcase'),
              onTap: () => _openFromDrawer(const UiShowcaseScreen()),
            ),
          ),
          FadeSlideIn(
            delay: stagger(5, stepMs: 70),
            offset: const Offset(-0.2, 0),
            child: ListTile(
              leading: const Icon(Icons.public, color: AppColors.primary),
              title: const Text('Web View'),
              onTap: () => _openFromDrawer(const WebViewScreen()),
            ),
          ),
          FadeSlideIn(
            delay: stagger(6, stepMs: 70),
            offset: const Offset(-0.2, 0),
            child: ListTile(
              leading:
                  const Icon(Icons.info_outline, color: AppColors.primary),
              title: const Text('About this lab'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Campus Hub',
                  applicationVersion: '2.0.0',
                  applicationIcon: const Icon(Icons.school_rounded,
                      color: AppColors.primary, size: 40),
                  children: const [
                    Text(
                      'Mobile Computing Lab 07: animated splash screen, '
                      'interactive animations, UI showcase and web view.',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ home page

  Widget _buildHomeContent() {
    final tasks = _repository.getTasks();
    final doneCount = tasks.where((t) => t.isDone).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 110),
      children: [
        FadeSlideIn(
          child: _HeroBanner(taskCount: tasks.length, doneCount: doneCount),
        ),
        const SizedBox(height: 18),
        FadeSlideIn(
          delay: stagger(1),
          child: const _SectionTitle('Campus highlights'),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: CampusData.highlights.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final place = CampusData.highlights[i];
              return FadeSlideIn(
                delay: stagger(i + 2, stepMs: 110),
                offset: const Offset(0.4, 0),
                child: SizedBox(
                  width: 102,
                  child: PlaceCard(
                    place: place,
                    heroPrefix: 'hl',
                    compact: true,
                    onTap: () => Navigator.push(
                      context,
                      fadeSlideRoute<void>(
                        PlaceDetailScreen(
                          place: place,
                          heroTag: 'hl-${place.label}',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        FadeSlideIn(
          delay: stagger(6),
          child: const _SectionTitle('My tasks'),
        ),
        const SizedBox(height: 6),
        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: Text('No tasks yet — tap "New task" to add one.'),
            ),
          ),
        for (var i = 0; i < tasks.length; i++)
          FadeSlideIn(
            key: ValueKey('fade-${tasks[i].id}'),
            delay: stagger(7 + i),
            child: _buildTaskTile(tasks[i], i),
          ),
      ],
    );
  }

  Widget _buildTaskTile(Task task, int index) {
    final accent = index.isEven ? AppColors.primary : AppColors.coral;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Dismissible(
        key: ValueKey(task.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 22),
          decoration: BoxDecoration(
            color: AppColors.coral,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete_outline, color: Colors.white),
        ),
        onDismissed: (_) => _deleteTask(task),
        child: PressScale(
          scale: 0.98,
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              dense: true,
              leading: Hero(
                tag: 'task-${task.id}',
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: accent,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Icon(
                      task.isDone
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      key: ValueKey(task.isDone),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  decoration:
                      task.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                task.description,
                style: const TextStyle(fontSize: 11),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openTask(task, accent),
            ),
          ),
        ),
      ),
    );
  }

  void _openTask(Task task, Color accent) {
    Navigator.push(
      context,
      fadeSlideRoute<void>(
        TaskDetailScreen(
          task: task,
          accent: accent,
          onToggle: () => _repository.toggleTask(task.id),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  Future<void> _addTask() async {
    final task = await Navigator.push<Task>(
      context,
      fadeSlideRoute<Task>(const AddTaskScreen()),
    );
    if (task != null) {
      setState(() {
        _repository.addTask(task);
        _selectedIndex = 0;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Task "${task.title}" added'),
          ),
        );
    }
  }

  void _deleteTask(Task task) {
    final index = _repository.getTasks().indexWhere((t) => t.id == task.id);
    setState(() => _repository.removeTask(task.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('"${task.title}" deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () =>
                setState(() => _repository.insertTask(index, task)),
          ),
        ),
      );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    );
  }
}

/// Gradient greeting banner with three animated counters.
class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.taskCount, required this.doneCount});

  final int taskCount;
  final int doneCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppTheme.gradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Good morning, Student ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const _WavingHand(),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Your campus workspace at a glance',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _GlassStat(
                  icon: Icons.checklist,
                  value: taskCount,
                  label: 'Tasks',
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: _GlassStat(
                  icon: Icons.menu_book_outlined,
                  value: 3,
                  label: 'Courses',
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: _GlassStat(
                  icon: Icons.event_outlined,
                  value: 5,
                  label: 'Events',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The 👋 emoji waves back and forth forever.
class _WavingHand extends StatefulWidget {
  const _WavingHand();

  @override
  State<_WavingHand> createState() => _WavingHandState();
}

class _WavingHandState extends State<_WavingHand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(begin: -0.06, end: 0.06)
          .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      alignment: Alignment.bottomRight,
      child: const Text('👋', style: TextStyle(fontSize: 16)),
    );
  }
}

class _GlassStat extends StatelessWidget {
  const _GlassStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      scale: 0.93,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(height: 6),
            AnimatedCounter(
              value: value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/animations.dart';
import '../../core/app_theme.dart';

/// A gallery of Flutter UI components and animations - every one is live.
class UiShowcaseScreen extends StatefulWidget {
  const UiShowcaseScreen({super.key});

  @override
  State<UiShowcaseScreen> createState() => _UiShowcaseScreenState();
}

class _UiShowcaseScreenState extends State<UiShowcaseScreen> {
  // inputs
  bool _switchOn = true;
  bool _checked = true;
  double _slider = 60;
  int _segment = 0;
  int _choice = 0;
  final Set<String> _filters = {'Flutter'};

  // animation demos
  bool _morphed = false;
  bool _crossFaded = false;
  bool _faded = true;
  bool _liked = false;
  int _page = 0;
  final _pageController = PageController(viewportFraction: 0.82);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      _banner(),
      _section('Buttons', Icons.smart_button_outlined, _buttons()),
      _section('Chips & selection', Icons.label_outline, _chips()),
      _section('Inputs & controls', Icons.tune, _controls()),
      _section('Animated widgets', Icons.animation, _animatedDemos()),
      _section('Loaders & progress', Icons.autorenew, _loaders()),
      _section('Carousel (PageView)', Icons.view_carousel_outlined, _carousel()),
      _section('Dialogs & sheets', Icons.chat_bubble_outline, _dialogs()),
      _section('Expansion list', Icons.expand_circle_down_outlined, _faq()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('UI Showcase')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 28),
        itemCount: sections.length,
        itemBuilder: (context, i) => FadeSlideIn(
          delay: stagger(i, stepMs: 70),
          child: sections[i],
        ),
      ),
    );
  }

  // ------------------------------------------------------------- layout

  Widget _banner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppTheme.gradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          Icon(Icons.widgets_rounded, color: Colors.white, size: 38),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Widget gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tap, drag and toggle everything on this page.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, IconData icon, Widget child) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------ sections

  Widget _buttons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilledButton(onPressed: () => _toast('Filled button'), child: const Text('Filled')),
        FilledButton.tonal(onPressed: () => _toast('Tonal button'), child: const Text('Tonal')),
        OutlinedButton(onPressed: () => _toast('Outlined button'), child: const Text('Outlined')),
        TextButton(onPressed: () => _toast('Text button'), child: const Text('Text')),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
          onPressed: () => _toast('Icon button'),
          icon: const Icon(Icons.rocket_launch),
          label: const Text('Launch'),
        ),
        IconButton.filledTonal(
          onPressed: () => setState(() => _liked = !_liked),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              _liked ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(_liked),
              color: _liked ? Colors.red : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _chips() {
    const topics = ['Flutter', 'Dart', 'Firebase', 'UI/UX'];
    const levels = ['Beginner', 'Intermediate', 'Advanced'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final t in topics)
              FilterChip(
                label: Text(t),
                selected: _filters.contains(t),
                onSelected: (on) => setState(() {
                  on ? _filters.add(t) : _filters.remove(t);
                }),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            for (var i = 0; i < levels.length; i++)
              ChoiceChip(
                label: Text(levels[i]),
                selected: _choice == i,
                onSelected: (_) => setState(() => _choice = i),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('Day'), icon: Icon(Icons.wb_sunny_outlined)),
            ButtonSegment(value: 1, label: Text('Week'), icon: Icon(Icons.view_week_outlined)),
            ButtonSegment(value: 2, label: Text('Month'), icon: Icon(Icons.calendar_month_outlined)),
          ],
          selected: {_segment},
          onSelectionChanged: (s) => setState(() => _segment = s.first),
        ),
      ],
    );
  }

  Widget _controls() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Search campus',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Notifications'),
          subtitle: Text(_switchOn ? 'You will get reminders' : 'Muted'),
          value: _switchOn,
          onChanged: (v) => setState(() => _switchOn = v),
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Remember me'),
          value: _checked,
          onChanged: (v) => setState(() => _checked = v ?? false),
        ),
        Row(
          children: [
            const Icon(Icons.volume_down),
            Expanded(
              child: Slider(
                value: _slider,
                min: 0,
                max: 100,
                divisions: 20,
                label: _slider.round().toString(),
                onChanged: (v) => setState(() => _slider = v),
              ),
            ),
            SizedBox(
              width: 36,
              child: Text('${_slider.round()}', textAlign: TextAlign.end),
            ),
          ],
        ),
      ],
    );
  }

  Widget _animatedDemos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tap the box to morph it (AnimatedContainer):'),
        const SizedBox(height: 10),
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _morphed = !_morphed),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              width: _morphed ? 190 : 90,
              height: _morphed ? 70 : 90,
              decoration: BoxDecoration(
                color: _morphed ? AppColors.coral : AppColors.primary,
                borderRadius: BorderRadius.circular(_morphed ? 35 : 20),
              ),
              alignment: Alignment.center,
              child: Icon(
                _morphed ? Icons.favorite : Icons.touch_app,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('AnimatedCrossFade'),
            FilledButton.tonal(
              onPressed: () => setState(() => _crossFaded = !_crossFaded),
              child: const Text('Switch'),
            ),
          ],
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 450),
          crossFadeState: _crossFaded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: _fadeBox(AppColors.primary, 'Hello 👋'),
          secondChild: _fadeBox(AppColors.coral, 'Campus Hub 🎓'),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('AnimatedOpacity'),
            Switch(
              value: _faded,
              onChanged: (v) => setState(() => _faded = v),
            ),
          ],
        ),
        AnimatedOpacity(
          opacity: _faded ? 1 : 0.1,
          duration: const Duration(milliseconds: 500),
          child: _fadeBox(AppColors.teal, 'Fade me'),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            _SpinningIcon(),
            SizedBox(width: 14),
            _PulsingHeart(),
            SizedBox(width: 14),
            Expanded(child: Text('Continuous rotation & pulse animations')),
          ],
        ),
      ],
    );
  }

  Widget _fadeBox(Color color, String text) {
    return Container(
      width: double.infinity,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _loaders() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const CircularProgressIndicator(),
            const _BouncingDots(),
            SizedBox(
              width: 60,
              height: 60,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 0.85),
                duration: const Duration(seconds: 2),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: v,
                      strokeWidth: 6,
                      backgroundColor: AppColors.background,
                    ),
                    Text('${(v * 100).round()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 0.7),
          duration: const Duration(milliseconds: 1600),
          curve: Curves.easeOutCubic,
          builder: (context, v, _) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: v, minHeight: 10),
          ),
        ),
      ],
    );
  }

  Widget _carousel() {
    const colors = [
      [AppColors.primary, AppColors.violet],
      [AppColors.coral, Color(0xFFFFB199)],
      [AppColors.teal, Color(0xFF5EEAD4)],
    ];
    const titles = ['Learn', 'Explore', 'Connect'];
    const icons = [Icons.menu_book, Icons.explore, Icons.groups];
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double page = _page.toDouble();
                  if (_pageController.hasClients &&
                      _pageController.position.haveDimensions) {
                    page = _pageController.page ?? page;
                  }
                  final scale = (1 - (page - i).abs() * 0.12).clamp(0.85, 1.0).toDouble();
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors[i]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[i], color: Colors.white, size: 36),
                      const SizedBox(height: 6),
                      Text(
                        titles[i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 3; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _page == i ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _page == i ? AppColors.primary : Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _dialogs() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.warning_amber_rounded),
          label: const Text('Dialog'),
          onPressed: () => showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              icon: const Icon(Icons.school, color: AppColors.primary),
              title: const Text('Welcome to Campus Hub'),
              content: const Text('This is a Material 3 AlertDialog.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Great!'),
                ),
              ],
            ),
          ),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.vertical_align_top),
          label: const Text('Bottom sheet'),
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (ctx) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final item in const [
                    (Icons.share, 'Share'),
                    (Icons.link, 'Copy link'),
                    (Icons.bookmark_border, 'Save'),
                  ])
                    ListTile(
                      leading: Icon(item.$1, color: AppColors.primary),
                      title: Text(item.$2),
                      onTap: () {
                        Navigator.pop(ctx);
                        _toast('${item.$2} tapped');
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.notifications_none),
          label: const Text('Snackbar'),
          onPressed: () => _toast('Hello from the snackbar!'),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.event),
          label: const Text('Date picker'),
          onPressed: () => showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
          ),
        ),
      ],
    );
  }

  Widget _faq() {
    return const Column(
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text('What is Campus Hub?'),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text('A student workspace for tasks, events and campus life.'),
              ),
            ),
          ],
        ),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text('Which widgets are animated?'),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text('Splash, Hero images, counters, lists, tabs, FAB and page routes.'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SpinningIcon extends StatefulWidget {
  const _SpinningIcon();

  @override
  State<_SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<_SpinningIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _c,
      child: const Icon(Icons.settings, size: 40, color: AppColors.primary),
    );
  }
}

class _PulsingHeart extends StatefulWidget {
  const _PulsingHeart();

  @override
  State<_PulsingHeart> createState() => _PulsingHeartState();
}

class _PulsingHeartState extends State<_PulsingHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.25)
          .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      child: const Icon(Icons.favorite, size: 36, color: AppColors.coral),
    );
  }
}

class _BouncingDots extends StatefulWidget {
  const _BouncingDots();

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Transform.translate(
                offset: Offset(
                  0,
                  -12 * math.max(0.0, math.sin(_c.value * 2 * math.pi - i * 0.7)),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: i == 1 ? AppColors.coral : AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

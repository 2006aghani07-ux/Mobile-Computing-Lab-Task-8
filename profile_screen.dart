import 'package:flutter/material.dart';

import '../../core/animations.dart';
import '../../core/app_theme.dart';
import '../../core/campus_data.dart';
import '../../core/network_photo.dart';
import '../showcase/ui_showcase_screen.dart';
import '../webview/web_view_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 20),
      children: [
        FadeSlideIn(
          child: SizedBox(
            height: 190,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: NetworkPhoto(
                      url: CampusData.profileBanner,
                      icon: Icons.apartment_rounded,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.elasticOut,
                      builder: (context, v, child) =>
                          Transform.scale(scale: v, child: child),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.person, size: 34, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        FadeSlideIn(
          delay: stagger(2),
          child: const Column(
            children: [
              Text(
                'Student User',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2),
              Text(
                'student@example.com',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        FadeSlideIn(
          delay: stagger(3),
          child: const Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(value: 3, label: 'Courses'),
                  _Stat(value: 12, label: 'Tasks done'),
                  _Stat(value: 3.8, label: 'GPA', decimals: 1),
                ],
              ),
            ),
          ),
        ),
        FadeSlideIn(
          delay: stagger(4),
          child: const _InfoTile(
            icon: Icons.school_outlined,
            color: AppColors.primary,
            title: 'Program',
            subtitle: 'Computer Science',
          ),
        ),
        FadeSlideIn(
          delay: stagger(5),
          child: const _InfoTile(
            icon: Icons.calendar_month_outlined,
            color: AppColors.coral,
            title: 'Semester',
            subtitle: 'Semester 1',
          ),
        ),
        const SizedBox(height: 10),
        FadeSlideIn(
          delay: stagger(6),
          child: _InfoTile(
            icon: Icons.info_outline,
            color: AppColors.teal,
            title: 'App information',
            subtitle: 'Campus Hub — lab prototype',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Campus Hub',
              applicationVersion: '2.0.0',
              children: const [Text('Built during a Flutter mobile computing lab.')],
            ),
          ),
        ),
        FadeSlideIn(
          delay: stagger(7),
          child: _InfoTile(
            icon: Icons.widgets_outlined,
            color: AppColors.violet,
            title: 'UI Showcase',
            subtitle: 'Buttons, inputs, animations and more',
            onTap: () => Navigator.push(
              context,
              fadeSlideRoute<void>(const UiShowcaseScreen()),
            ),
          ),
        ),
        FadeSlideIn(
          delay: stagger(8),
          child: _InfoTile(
            icon: Icons.public,
            color: AppColors.primary,
            title: 'Campus Web View',
            subtitle: 'Browse websites inside the app',
            onTap: () => Navigator.push(
              context,
              fadeSlideRoute<void>(const WebViewScreen()),
            ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.decimals = 0});

  final num value;
  final String label;
  final int decimals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCounter(
          value: value,
          decimals: decimals,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      scale: 0.98,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          leading: Icon(icon, color: color, size: 20),
          title: Text(title, style: const TextStyle(fontSize: 13)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
          trailing: onTap == null ? null : const Icon(Icons.chevron_right, size: 18),
          onTap: onTap,
        ),
      ),
    );
  }
}

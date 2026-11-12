import 'package:flutter/material.dart';

import '../../core/animations.dart';
import '../../core/app_theme.dart';
import '../../core/campus_data.dart';
import '../../core/place_card.dart';
import 'place_detail_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final places = CampusData.explore;
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: places.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, i) {
            final place = places[i];
            final tag = 'ex-${place.label}';
            return FadeSlideIn(
              delay: stagger(i, stepMs: 110),
              offset: const Offset(0, 0.2),
              child: PlaceCard(
                place: place,
                heroPrefix: 'ex',
                onTap: () => Navigator.push(
                  context,
                  fadeSlideRoute<void>(
                    PlaceDetailScreen(place: place, heroTag: tag),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 18),
        FadeSlideIn(
          delay: stagger(6, stepMs: 110),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Upcoming events',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        FadeSlideIn(
          delay: stagger(7, stepMs: 110),
          child: const _EventTile(
            icon: Icons.mic,
            color: AppColors.coral,
            title: 'Tech Workshop',
            subtitle: 'Friday, 10:00 AM · Hall A',
          ),
        ),
        FadeSlideIn(
          delay: stagger(8, stepMs: 110),
          child: const _EventTile(
            icon: Icons.school,
            color: AppColors.primary,
            title: 'Career Seminar',
            subtitle: 'Monday, 2:00 PM · Auditorium',
          ),
        ),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      scale: 0.97,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
          onTap: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Reminder set for $title'),
                ),
              );
          },
        ),
      ),
    );
  }
}

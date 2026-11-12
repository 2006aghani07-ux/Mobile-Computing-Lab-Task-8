import 'package:flutter/material.dart';

class CampusPlace {
  const CampusPlace({
    required this.label,
    required this.icon,
    required this.imageUrl,
    required this.description,
  });

  final String label;
  final IconData icon;
  final String imageUrl;
  final String description;
}

String _photo(String id) =>
    'https://images.unsplash.com/$id?auto=format&fit=crop&w=900&q=70';

class CampusData {
  static final library = CampusPlace(
    label: 'Library',
    icon: Icons.local_library_rounded,
    imageUrl: _photo('photo-1481627834876-b7833e8f5570'),
    description:
        'Quiet study zones, thousands of books, journals and group discussion rooms. Open from morning until late evening during the semester.',
  );
  static final events = CampusPlace(
    label: 'Events',
    icon: Icons.event_rounded,
    imageUrl: _photo('photo-1492684223066-81342ee5ff30'),
    description:
        'Workshops, seminars, society nights and festivals. Check the upcoming events list so you never miss anything on campus.',
  );
  static final sports = CampusPlace(
    label: 'Sports',
    icon: Icons.sports_soccer_rounded,
    imageUrl: _photo('photo-1431324155629-1a6deb1dec8d'),
    description:
        'Football, cricket, basketball and fitness facilities. Join a team or simply stay active between lectures.',
  );
  static final labs = CampusPlace(
    label: 'Labs',
    icon: Icons.science_rounded,
    imageUrl: _photo('photo-1532094349884-543bc11b234d'),
    description:
        'Computer, electronics and science laboratories with modern equipment for your practical work and projects.',
  );
  static final clubs = CampusPlace(
    label: 'Clubs',
    icon: Icons.groups_rounded,
    imageUrl: _photo('photo-1529156069898-49953e39b3ac'),
    description:
        'Meet new friends and build skills with technical, cultural and community societies.',
  );
  static final cafeteria = CampusPlace(
    label: 'Cafeteria',
    icon: Icons.restaurant_rounded,
    imageUrl: _photo('photo-1554118811-1e0d58224f24'),
    description:
        'Fresh meals, snacks and coffee - the favourite hangout spot between classes.',
  );
  static final projects = CampusPlace(
    label: 'Projects',
    icon: Icons.code_rounded,
    imageUrl: _photo('photo-1517694712202-14dd9538aa97'),
    description:
        'Showcase and collaborate on final-year, research and app-development projects.',
  );

  static final highlights = [library, events, sports, labs];
  static final explore = [events, library, sports, clubs, cafeteria, projects];

  static final profileBanner = _photo('photo-1562774053-701939374585');
}

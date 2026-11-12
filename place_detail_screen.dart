import 'package:flutter/material.dart';

import '../../core/animations.dart';
import '../../core/app_theme.dart';
import '../../core/campus_data.dart';
import '../../core/network_photo.dart';
import '../webview/web_view_screen.dart';

/// Opened from the Home highlights / Explore grid. The photo flies in (Hero).
class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({
    super.key,
    required this.place,
    required this.heroTag,
  });

  final CampusPlace place;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 320,
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(28),
                    ),
                    child: NetworkPhoto(url: place.imageUrl, icon: place.icon),
                  ),
                ),
              ),
              Positioned(
                top: top + 8,
                left: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeSlideIn(
                  delay: stagger(1),
                  child: Row(
                    children: [
                      Icon(place.icon, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        place.label,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FadeSlideIn(
                  delay: stagger(2),
                  child: Text(
                    place.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 24),
                FadeSlideIn(
                  delay: stagger(3),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        fadeSlideRoute<void>(const WebViewScreen()),
                      ),
                      icon: const Icon(Icons.public),
                      label: const Text('Visit campus website'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

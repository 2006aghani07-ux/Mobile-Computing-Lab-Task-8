import 'package:flutter/material.dart';
import 'animations.dart';
import 'campus_data.dart';
import 'network_photo.dart';

/// Rounded photo tile with a label. Shared by the Home highlights and the
/// Explore grid. The photo is a [Hero] so it flies into the detail screen.
class PlaceCard extends StatelessWidget {
  const PlaceCard({
    super.key,
    required this.place,
    required this.heroPrefix,
    required this.onTap,
    this.compact = false,
  });

  final CampusPlace place;
  final String heroPrefix;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(compact ? 16 : 18);
    return PressScale(
      child: Hero(
        tag: '$heroPrefix-${place.label}',
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              NetworkPhoto(url: place.imageUrl, icon: place.icon),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xB3000000)],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 8,
                right: 8,
                child: compact
                    ? Text(
                        place.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          decoration: TextDecoration.none,
                        ),
                      )
                    : Row(
                        children: [
                          Icon(place.icon, color: Colors.white, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            place.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onTap),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

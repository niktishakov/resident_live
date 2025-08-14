import "dart:ui";

import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

enum TripStatus { upcoming, current, past }

// Extension to get trip status
extension TripStatusExtension on TripEntity {
  TripStatus get status {
    final now = DateTime.now();
    if (now.isBefore(fromDate)) {
      return TripStatus.upcoming;
    } else if (now.isAfter(toDate)) {
      return TripStatus.past;
    } else {
      return TripStatus.current;
    }
  }
}

class TripStatusBadge extends StatelessWidget {
  const TripStatusBadge({required this.trip, super.key});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final status = trip.status;
    final (color, text) = _getStatusInfo(status);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: context.rlTheme.body12.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, String) _getStatusInfo(TripStatus status) {
    switch (status) {
      case TripStatus.upcoming:
        return (const Color(0xFF3B82F6), "Upcoming");
      case TripStatus.current:
        return (const Color(0xFF10B981), "Current");
      case TripStatus.past:
        return (const Color(0xFF6B7280), "Completed");
    }
  }
}

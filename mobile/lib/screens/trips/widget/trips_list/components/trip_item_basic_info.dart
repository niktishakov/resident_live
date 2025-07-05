import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

class TripItemBasicInfo extends StatelessWidget {
  const TripItemBasicInfo({
    required this.countryName,
    required this.fromDate,
    required this.toDate,
    required this.days,
    required this.countryCode,
    required this.isExpanded,
    super.key,
  });

  final String countryName;
  final DateTime fromDate;
  final DateTime toDate;
  final int days;
  final String countryCode;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final tripStatus = _getTripStatus();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Country flag with better contrast
            Container(
              width: 28,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.asset(
                  CountryCode.fromCountryCode(countryCode).flagUri ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.white.withValues(alpha: 0.2),
                    child: Center(
                      child: Text(
                        countryCode.toUpperCase(),
                        style: theme.body12.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Trip status with better visibility
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getTripStatusColor(tripStatus).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                _getTripStatusText(tripStatus),
                style: theme.body12.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(width: 12),

            // Duration badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
              ),
              child: Text(
                "$days days",
                style: theme.body12.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(width: 12),

            // Expand indicator with backdrop
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(CupertinoIcons.chevron_down, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Country name with text shadow for better readability
        Text(
          countryName,
          style: theme.body20.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Dates with better contrast
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "${fromDate.toMMMDDString()} - ${toDate.toMMMDDString()}",
            style: theme.body14.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  _TripStatus _getTripStatus() {
    final now = DateTime.now();
    if (now.isBefore(fromDate)) {
      return _TripStatus.upcoming;
    } else if (now.isAfter(toDate)) {
      return _TripStatus.past;
    } else {
      return _TripStatus.current;
    }
  }

  Color _getTripStatusColor(_TripStatus status) {
    switch (status) {
      case _TripStatus.upcoming:
        return Colors.blue;
      case _TripStatus.current:
        return Colors.green;
      case _TripStatus.past:
        return Colors.grey.shade600;
    }
  }

  String _getTripStatusText(_TripStatus status) {
    switch (status) {
      case _TripStatus.upcoming:
        return "Upcoming";
      case _TripStatus.current:
        return "Current";
      case _TripStatus.past:
        return "Past";
    }
  }
}

enum _TripStatus { upcoming, current, past }

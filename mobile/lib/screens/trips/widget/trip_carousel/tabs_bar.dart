import "package:flutter/material.dart";
import "package:resident_live/screens/trips/widget/trip_carousel/trips_carousel.dart";
import "package:resident_live/shared/shared.dart";

class TabsBar extends StatelessWidget {
  const TabsBar({required this.selectedFilter, required this.onSelected, super.key});

  final TripFilter selectedFilter;
  final Function(TripFilter) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTabButton(context, "ALL", TripFilter.all, selectedFilter, onSelected),
          _buildTabButton(context, "CURRENT", TripFilter.current, selectedFilter, onSelected),
          _buildTabButton(context, "UPCOMING", TripFilter.coming, selectedFilter, onSelected),
          _buildTabButton(context, "COMPLETED", TripFilter.completed, selectedFilter, onSelected),
        ],
      ),
    );
  }
}

Widget _buildTabButton(
  BuildContext context,
  String title,
  TripFilter filter,
  TripFilter selectedFilter,
  Function(TripFilter) onSelected,
) {
  final theme = context.rlTheme;
  final isActive = selectedFilter == filter;

  return GestureDetector(
    onTap: () => onSelected(filter),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Text(
        title,
        style: theme.body12.copyWith(
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );
}

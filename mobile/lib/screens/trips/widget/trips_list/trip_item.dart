import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/screens/map/cubit/country_bg_cubit.dart";
import "package:resident_live/screens/trips/widget/trips_list/components/trip_item_background.dart";
import "package:resident_live/screens/trips/widget/trips_list/components/trip_item_basic_info.dart";
import "package:resident_live/screens/trips/widget/trips_list/components/trip_item_expanded_content.dart";
import "package:resident_live/screens/trips/widget/trips_list/components/trip_item_header.dart";
import "package:resident_live/shared/shared.dart";

class TripItem extends StatefulWidget {
  const TripItem({required this.trip, this.onTap, this.onDelete, super.key});

  final TripEntity trip;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  State<TripItem> createState() => _TripItemState();
}

class _TripItemState extends State<TripItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final countryName =
        CountryCode.fromCountryCode(widget.trip.countryCode).localize(context).name ?? "Unknown";

    return BlocProvider(
      create: (_) =>
          getIt<CountryBackgroundCubit>()..loadCountryBackground(widget.trip.countryCode),
      child: Dismissible(
        key: Key(widget.trip.id),
        onDismissed: (direction) => widget.onDelete?.call(),
        background: _buildDismissBackground(context, theme),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              constraints: BoxConstraints(
                minHeight: 140,
                maxHeight: _isExpanded ? double.infinity : 140,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.bgAccent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // Background image
                  Positioned.fill(child: TripItemBackground(trip: widget.trip)),
                  // Content
                  _buildContent(countryName, theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground(BuildContext context, RlTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.red.withValues(alpha: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(context.t.commonDelete, style: theme.body14.copyWith(color: Colors.white)),
          context.hBox8,
          const Icon(CupertinoIcons.delete, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildContent(String countryName, RlTheme theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TripItemHeader(days: widget.trip.days, isExpanded: _isExpanded),
          const SizedBox(height: 16),
          TripItemBasicInfo(
            countryName: countryName,
            fromDate: widget.trip.fromDate,
            toDate: widget.trip.toDate,
            days: widget.trip.days,
            countryCode: widget.trip.countryCode,
            isExpanded: _isExpanded,
          ),
          TripItemExpandedContent(animation: _animation, trip: widget.trip),
        ],
      ),
    );
  }
}

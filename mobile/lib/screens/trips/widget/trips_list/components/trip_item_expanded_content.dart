import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/shared/shared.dart";

class TripItemExpandedContent extends StatelessWidget {
  const TripItemExpandedContent({required this.animation, required this.trip, super.key});

  final Animation<double> animation;
  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final daysAfterTrip = _getDaysAfterTrip();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: animation,
          child: AnimatedOpacity(
            opacity: animation.value,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider
                  Container(
                    height: 1,
                    color: theme.borderPrimary.withValues(alpha: 0.1),
                    margin: const EdgeInsets.only(bottom: 16),
                  ),

                  // Tax residence warning
                  if (daysAfterTrip > 183)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.exclamationmark_triangle,
                            color: Colors.amber.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Tax residence risk: You've been in this country for $daysAfterTrip days",
                              style: theme.body12.copyWith(
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3), width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.checkmark_circle,
                            color: Colors.green.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Safe travel: No tax residence concerns",
                              style: theme.body12.copyWith(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: CupertinoIcons.pencil,
                          label: "Edit Trip",
                          onTap: () => _editTrip(context),
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: CupertinoIcons.map,
                          label: "Show on Map",
                          onTap: () => _showOnMap(context),
                          theme: theme,
                          isSecondary: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required RlTheme theme,
    bool isSecondary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSecondary ? Colors.transparent : theme.bgAccent,
        borderRadius: BorderRadius.circular(8),
        border: isSecondary ? Border.all(color: theme.borderPrimary.withValues(alpha: 0.2)) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isSecondary ? theme.textSecondary : Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: theme.body14.copyWith(
                    color: isSecondary ? theme.textSecondary : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getDaysAfterTrip() {
    final now = DateTime.now();
    return now.difference(trip.toDate).inDays;
  }

  void _editTrip(BuildContext context) {
    context.pushNamed(ScreenNames.addTrip, extra: trip);
  }

  void _showOnMap(BuildContext context) {
    context.pushNamed(ScreenNames.map, extra: trip);
  }
}

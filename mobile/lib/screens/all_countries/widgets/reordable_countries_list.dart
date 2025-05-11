part of "../all_countries_screen.dart";

class ReordableCountriesList extends StatelessWidget {
  const ReordableCountriesList({
    required this.isEditing,
    required this.selected,
    required this.toggleSelection,
    super.key,
  });

  final bool isEditing;
  final List<String> selected;
  final Function({required String countryCode, required bool isSelected}) toggleSelection;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      bloc: getIt<GetUserCubit>(),
      builder: (c, state) {
        final user = state.data;

        return RlCard(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            children: [
              Opacity(
                opacity: isEditing ? 0.0 : 1.0,
                child: IgnorePointer(
                  ignoring: isEditing,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final country = user?.countries.entries.toList()[index];
                      final countryCode = country?.key ?? "";
                      final daysSpent = user?.daysSpentIn(countryCode) ?? 0;

                      return _CountryItem(
                        countryCode: countryCode,
                        daysSpent: daysSpent,
                        toggleSelection: toggleSelection,
                        isEditing: isEditing,
                        isSelected: selected.contains(
                          country?.key ?? "",
                        ),
                        isLast: index == (user?.countries.length ?? 0) - 1,
                      );
                    },
                    itemCount: user?.countries.length ?? 0,
                  ),
                ),
              ),

              // Reorderable ListView
              Opacity(
                opacity: isEditing ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !isEditing,
                  child: ReorderableListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final country = user?.countries.entries.toList()[index];
                      final countryCode = country?.key ?? "";
                      final daysSpent = user?.daysSpentIn(countryCode) ?? 0;

                      return _CountryItem(
                        key: Key(countryCode),
                        countryCode: countryCode,
                        daysSpent: daysSpent,
                        toggleSelection: toggleSelection,
                        isEditing: isEditing,
                        isSelected: selected.contains(countryCode),
                        isLast: index == (user?.countries.length ?? 0) - 1,
                      );
                    },
                    itemCount: user?.countries.length ?? 0,
                    onReorder: (
                      oldIndex,
                      newIndex,
                    ) {},
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

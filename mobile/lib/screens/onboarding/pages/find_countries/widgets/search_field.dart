part of "../find_countries_page.dart";

class SearchField extends StatelessWidget {
  const SearchField({required this.onChanged, required this.controller, super.key});

  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controller,
        style: theme.body16,
        decoration: InputDecoration(
          fillColor: theme.bgModal,
          filled: true,

          // Prefix
          prefixIconColor: theme.iconSecondary,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Icon(CupertinoIcons.search, size: 24),
          ),
          prefixIconConstraints: const BoxConstraints(),

          // Postfix
          suffixIconColor: theme.iconSecondary,
          suffixIcon: ValueListenableBuilder(
            valueListenable: controller,
            builder:
                (context, value, child) => AnimatedSwitcher(
                  duration: 100.ms,
                  child:
                      controller.text.isNotEmpty
                          ? GestureDetector(
                            onTap: controller.clear,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 12.0),
                              child: Icon(CupertinoIcons.clear_circled_solid, size: 24),
                            ),
                          )
                          : null,
                ),
          ),

          // Hint
          hintText: context.t.whereHaveYouBeenSearchCountries,
          hintStyle: theme.body16.copyWith(color: theme.textSecondary),

          // Borders
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: theme.borderAccent),
          ),
        ),
        onChanged: onChanged,
        onTapOutside: (value) => FocusScope.of(context).unfocus(),
      ).animate().fade(delay: 1000.ms),
    );
  }
}

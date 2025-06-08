part of "../find_countries_page.dart";

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.selectedCountries, required this.onNextPage});
  final List<String> selectedCountries;
  final VoidCallback onNextPage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: selectedCountries.isNotEmpty,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: selectedCountries.isNotEmpty ? 48 : 0,
        curve: Curves.fastOutSlowIn,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: selectedCountries.isNotEmpty ? 100.0 : 0.0,
            end: selectedCountries.isNotEmpty ? 0.0 : 100.0,
          ),
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: Center(
                child: PrimaryButton(
                  onPressed:
                      selectedCountries.isNotEmpty
                          ? () {
                            FocusScope.of(context).unfocus();
                            onNextPage();
                          }
                          : null,
                  label: context.t.commonContinue,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

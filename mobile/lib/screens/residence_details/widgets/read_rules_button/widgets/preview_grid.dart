part of "../read_rules_modal.dart";

class _PreviewGrid extends StatelessWidget {
  const _PreviewGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _PreviewCard(title: "Deloitte", url: deloitteUrl),
        _PreviewCard(title: "PWC", url: pwcUrl),
        _PreviewCard(title: "KPMG", url: kpmgUrl),
        _PreviewCard(title: "OECD", url: oecdUrl),
      ],
    );
  }
}

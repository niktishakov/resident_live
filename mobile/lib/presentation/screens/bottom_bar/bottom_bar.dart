part of 'bottom_bar_scaffold.dart';

class AiBottomBar extends StatelessWidget {
  AiBottomBar({
    Key? key,
    required this.state,
  }) : super(key: key);

  final GoRouterState state;

  final List<AiBottomBarItem> _items = [
    AiBottomBarItem(
      asset: CupertinoIcons.home,
      assetSelected: CupertinoIcons.home,
      label: 'Home',
      path: ScreenNames.home,
    ),
  ];

  String get currentPath => state.uri.toString();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black,
        border: const Border(
          top: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 20,
            right: 20,
          ),
          child: Row(
            children: _items.map((item) {
              return _buildIconButton(context, item);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, AiBottomBarItem item) {
    final isSelected = currentPath == item.path;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          final isTheSameTab = GoRouterState.of(context).fullPath == item.path;
          if (isTheSameTab && context.canPop()) {
            context.pop();
            return;
          }

          context.go(item.path);
        },
        child: SizedBox(
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: AnimatedSwitcher(
                      duration: kThemeChangeDuration,
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: FadeTransition(
                            opacity:
                                Tween<double>(begin: 0.5, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        key: ValueKey(isSelected),
                        item.asset,
                        size: 24,
                        color:
                            isSelected ? Colors.blue : const Color(0xff868991),
                      ),
                    ),
                  ),
                  // const Gap(2),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: isSelected ? Colors.blue : const Color(0xff868991),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AiBottomBarItem {
  final String path;
  final IconData asset;
  final IconData assetSelected;
  final String label;

  const AiBottomBarItem({
    required this.path,
    required this.asset,
    required this.assetSelected,
    required this.label,
  });
}

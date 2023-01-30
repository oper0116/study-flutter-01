import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AppBarPage extends StatefulWidget {
  const AppBarPage({
    Key? key,
    required this.restorationId,
  }) : super(key: key);

  final String restorationId;

  @override
  State<AppBarPage> createState() => _AppBarPageState();
}

class _AppBarPageState extends State<AppBarPage> with RestorationMixin {
  final RestorableInt _currentIndex = RestorableInt(0);

  @override
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_currentIndex, 'bottom_navigation_tab_index');
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    var bottomNavaigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.add_comment), label: '카테고리'),
      BottomNavigationBarItem(icon: Icon(Icons.api_sharp), label: '선물하기'),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
      BottomNavigationBarItem(icon: Icon(Icons.my_location), label: 'My'),
      BottomNavigationBarItem(icon: Icon(Icons.abc), label: '최근 본'),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          icon: Icon(Icons.menu),
          onPressed: () => {},
        ),
        title: Text('AppBar'),
      ),
      body: Center(
        child: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
            return FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: _NavigationDestinationView(
              key: UniqueKey(),
              item: bottomNavaigationBarItems[_currentIndex.value]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavaigationBarItems,
        currentIndex: _currentIndex.value,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: textTheme.bodySmall!.fontSize!,
        unselectedFontSize: textTheme.bodySmall!.fontSize!,
        onTap: (index) {
          setState(() {
            _currentIndex.value = index;
          });
        },
      ),
    );
  }
}

class _NavigationDestinationView extends StatelessWidget {
  const _NavigationDestinationView({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BottomNavigationBarItem item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExcludeSemantics(
          child: Center(
            child: Text('$this.item'),
          ),
        )
      ],
    );
  }
}

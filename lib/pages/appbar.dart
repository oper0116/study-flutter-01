import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/tab/photo_list.dart';

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

    // Widget page;
    // switch (_currentIndex.value.toInt()) {
    //   case 0:
    //     page = PhotoList();
    //     break;
    //   default:
    //     throw UnimplementedError('no widget for $_currentIndex');
    // }

    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text('HanDongHee'),
      accountEmail: Text('oper0116@gmail.com'),
      currentAccountPicture: const CircleAvatar(child: FlutterLogo(size: 42.0)),
    );

    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          title: Text('List1'),
          leading: Icon(Icons.favorite),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('List2'),
          leading: Icon(Icons.abc),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    return Scaffold(
        appBar: AppBar(
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
                currentIndex: _currentIndex.value.toInt(),
                item: bottomNavaigationBarItems[_currentIndex.value]),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavaigationBarItems,
          currentIndex: _currentIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: textTheme.bodySmall!.fontSize!,
          selectedItemColor: colorScheme.onPrimary,
          unselectedFontSize: textTheme.bodySmall!.fontSize!,
          unselectedItemColor: colorScheme.onPrimary.withOpacity(0.25),
          backgroundColor: colorScheme.primary,
          onTap: (index) {
            setState(() {
              _currentIndex.value = index;
            });
          },
        ),
        endDrawer: Drawer(
          child: drawerItems,
        ));
  }
}

class _NavigationDestinationView extends StatelessWidget {
  const _NavigationDestinationView({
    Key? key,
    required this.currentIndex,
    required this.item,
  }) : super(key: key);

  final num currentIndex;
  final BottomNavigationBarItem item;

  @override
  Widget build(BuildContext context) {
    print(key);

    print('currentIndex: $currentIndex');

    Widget page;
    switch (currentIndex) {
      case 0:
        page = PhotoList();
        break;
      default:
        page = Center(child: Text('a'));
        break;
    }

    return Stack(
      children: [
        ExcludeSemantics(
          child: page,
        )
      ],
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text('HanDongHee'),
      accountEmail: Text('oper0116@gmail.com'),
      currentAccountPicture: const CircleAvatar(child: FlutterLogo(size: 42.0)),
    );

    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          title: Text('List1'),
          leading: Icon(Icons.favorite),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('List2'),
          leading: Icon(Icons.abc),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    return drawerItems;
  }
}

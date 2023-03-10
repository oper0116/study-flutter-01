import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/appbar.dart';
import 'package:flutter_application_1/pages/detail.dart';
import 'package:flutter_application_1/provider/sidebar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => MyAppState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
        // home: MyHomePage(),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/detail': (context) => DetailPage(),
          '/appbar': (context) =>
              AppBarPage(restorationId: 'bottom_navigation_tab_index')
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = DetailPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(children: [
          SafeArea(
            child: NavigationRail(
              extended: constraints.maxWidth >= 600,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_alert_rounded),
                  label: Text('Detail Page Move'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_a_photo),
                  label: Text('AppBar'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) => {
                setState(() {
                  if (value == 2) {
                    Navigator.pushNamed(context, '/detail');
                    return;
                  }

                  if (value == 3) {
                    Navigator.pushNamed(context, '/appbar');
                    return;
                  }
                  selectedIndex = value;
                })
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          )
        ]),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          BigCard(pair: pair),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          )
        ]),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            pair.asLowerCase,
            style: style,
            semanticsLabel: pair.asPascalCase,
          )),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Text('You have '
            '${appState.favorites.length} favorites:'),
      ),
      for (var pair in appState.favorites)
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text(pair.asLowerCase),
        ),
    ]);
  }
}

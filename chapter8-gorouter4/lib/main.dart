import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fooderlich_theme.dart';
import 'models/models.dart';
import 'navigation/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appStateManager = AppStateManager();
  appStateManager.initializeApp();
  runApp(Fooderlich(
    appStateManager: appStateManager));
}

class Fooderlich extends StatefulWidget {
  final AppStateManager appStateManager;

  const Fooderlich({super.key, required this.appStateManager,});

  @override
  _FooderlichState createState() => _FooderlichState();
}

class _FooderlichState extends State<Fooderlich> {
  late final _groceryManager = GroceryManager();
  late final _profileManager = ProfileManager();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _groceryManager),
        ChangeNotifierProvider(
          create: (context) => widget.appStateManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        ),
        Provider<AppRouter>(
          lazy: false,
          create: (BuildContext createContext) => AppRouter(
            widget.appStateManager,
            _profileManager, 
            _groceryManager)
        ),
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = FooderlichTheme.dark();
          } else {
            theme = FooderlichTheme.light();
          }

          final router = Provider.of<AppRouter>(context, listen: false).router;

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: theme,
            title: 'Fooderlich',
            // backButtonDispatcher: RootBackButtonDispatcher(),
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            routerDelegate: router.routerDelegate,
          );
        },
      ),
    );
  }
}

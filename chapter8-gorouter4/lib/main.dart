import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'fooderlich_theme.dart';
import 'models/models.dart';
import 'screens/screens.dart';

void main() {
  runApp(const Fooderlich());
}

class Fooderlich extends StatefulWidget {
  const Fooderlich({Key? key}) : super(key: key);

  @override
  _FooderlichState createState() => _FooderlichState();
}

class _FooderlichState extends State<Fooderlich> {
  final _groceryManager = GroceryManager();
  late final _profileManager = ProfileManager();
  late final _appStateManager = AppStateManager();

  late final _router = GoRouter(
      urlPathStrategy: UrlPathStrategy.path,
      debugLogDiagnostics: true,
      refreshListenable: _appStateManager,
      routes: [
        GoRoute(
          name: 'init',
          path: '/init',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: 'onboarding',
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
            name: 'home',
            path: '/:tab',
            builder: (context, state) {
              final query = int.tryParse(state.params['tab'] ?? '') ?? 0;
              return Home(
                key: state.pageKey,
                currentTab: query);
            },
            routes: [
              GoRoute(
                  name: 'profile',
                  path: 'profile',
                  builder: (context, state) {
                    return ProfileScreen(user: _profileManager.getUser);
                  },
                  routes: [
                    GoRoute(
                      name: 'rw',
                      path: 'rw',
                      builder: (context, state) => WebViewScreen(),
                    ),
                  ]),
              GoRoute(
                  name: 'item',
                  path: 'item/:id',
                  builder: (context, state) {
                    final itemId = state.params['id'] ?? '';
                    final item = _groceryManager.getGroceryItem(itemId);
                    return GroceryItemScreen(
                      originalItem: item,
                      onCreate: (item) {
                        _groceryManager.addItem(item);
                      },
                      onUpdate: (item) {
                        _groceryManager.updateItem(item);
                      },
                    );
                  }),
            ]),
      ],
      errorPageBuilder: (context, state) {
        return MaterialPage(
            key: state.pageKey,
            child: Scaffold(body: Center(child: Text(state.error.toString()))));
      },
      redirect: (state) {
        // Check if app has been initialized
        final didInitialize = _appStateManager.isInitialized;
        final intializing = state.subloc == '/init';
        if (!didInitialize) return intializing ? null : '/init';

        // Check if the user has already logged in
        final loggedIn = _appStateManager.isLoggedIn;
        final loggingIn = state.subloc == '/login';
        if (!loggedIn) return loggingIn ? null : '/login';

        // Check if the user has already gone through onboarding.
        final isOnboardingComplete = _appStateManager.isOnboardingComplete;
        final onboarding = state.subloc == '/onboarding';
        if (!isOnboardingComplete) return onboarding ? null : '/onboarding';

        // If app has been initialized, user logged in, and complete onboarding
        // Show the home screen.
        final atHome = state.subloc == '/';
        // Stop redirecting if user is at home.
        if (atHome) return null;

        if (loggingIn || intializing || onboarding)
          return '/0';
        // Stop redirecting
        return null;
      });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _groceryManager),
        ChangeNotifierProvider(
          create: (context) => _appStateManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        )
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = FooderlichTheme.dark();
          } else {
            theme = FooderlichTheme.light();
          }

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: theme,
            title: 'Fooderlich',
            backButtonDispatcher: RootBackButtonDispatcher(),
            // 1
            routeInformationParser: _router.routeInformationParser,
            routeInformationProvider: _router.routeInformationProvider,
            // 2
            routerDelegate: _router.routerDelegate,
          );
        },
      ),
    );
  }
}

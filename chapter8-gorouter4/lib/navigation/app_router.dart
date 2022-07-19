import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state_manager.dart';
import '../models/grocery_manager.dart';
import '../models/profile_manager.dart';
import '../screens/screens.dart';

class AppRouter {
  final AppStateManager appStateManager;
  final ProfileManager profileManager;
  final GroceryManager groceryManager;

  AppRouter(this.appStateManager, this.profileManager, this.groceryManager);

  late final router = GoRouter(
      urlPathStrategy: UrlPathStrategy.path,
      debugLogDiagnostics: true,
      refreshListenable: appStateManager,
      initialLocation: '/login',
      routes: [
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
              final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
              return Home(key: state.pageKey, currentTab: tab);
            },
            routes: [
              GoRoute(
                  name: 'profile',
                  path: 'profile',
                  builder: (context, state) {
                    final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
                    return ProfileScreen(
                      user: profileManager.getUser,
                      currentTab: tab);
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
                    final item = groceryManager.getGroceryItem(itemId);
                    return GroceryItemScreen(
                      originalItem: item,
                      onCreate: (item) {
                        groceryManager.addItem(item);
                      },
                      onUpdate: (item) {
                        groceryManager.updateItem(item);
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

        // Check if the user has already logged in
        final loggedIn = appStateManager.isLoggedIn;
        final loggingIn = state.subloc == '/login';
        if (!loggedIn) return loggingIn ? null : '/login';

        // Check if the user has already gone through onboarding.
        final isOnboardingComplete = appStateManager.isOnboardingComplete;
        final onboarding = state.subloc == '/onboarding';
        if (!isOnboardingComplete) return onboarding ? null : '/onboarding';

        // If app has been initialized, user logged in, and complete onboarding
        // Show the home screen.
        final atHome = state.subloc == '/';
        // Stop redirecting if user is at home.
        if (atHome) return null;

        if (loggingIn || onboarding) return '/0';
        //Stop redirecting
        return null;
      });
}

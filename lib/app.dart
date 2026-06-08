import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/services/app_repository.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/orders/screens/create_order_screen.dart';
import 'features/orders/screens/order_details_screen.dart';
import 'features/orders/screens/orders_catalog_screen.dart';
import 'features/orders/screens/respond_order_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/specialists/screens/specialist_details_screen.dart';
import 'features/specialists/screens/specialists_catalog_screen.dart';
import 'shared/theme/app_theme.dart';

class ServiceMarketplaceApp extends StatefulWidget {
  const ServiceMarketplaceApp({
    super.key,
    required this.repository,
    required this.authController,
  });

  final AppRepository repository;
  final AuthController authController;

  @override
  State<ServiceMarketplaceApp> createState() => _ServiceMarketplaceAppState();
}

class _ServiceMarketplaceAppState extends State<ServiceMarketplaceApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    refreshListenable: widget.authController,
    redirect: (context, state) {
      final auth = widget.authController;
      final location = state.matchedLocation;
      final isGuestOnlyPath = location == '/auth';
      final needsAuth = location == '/profile' ||
          location == '/orders/create' ||
          location.endsWith('/respond');

      if (!auth.isAuthenticated && needsAuth) {
        return '/auth';
      }

      if (auth.isAuthenticated && isGuestOnlyPath) {
        return '/';
      }

      if (location == '/orders/create' && !auth.isCustomer) {
        return '/';
      }

      if (location.endsWith('/respond') && !auth.isSpecialist) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/specialists',
        builder: (context, state) => const SpecialistsCatalogScreen(),
      ),
      GoRoute(
        path: '/specialists/:id',
        builder: (context, state) => SpecialistDetailsScreen(
          specialistId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersCatalogScreen(),
      ),
      GoRoute(
        path: '/orders/create',
        builder: (context, state) => const CreateOrderScreen(),
      ),
      GoRoute(
        path: '/orders/:id',
        builder: (context, state) => OrderDetailsScreen(
          orderId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/:id/respond',
        builder: (context, state) => RespondOrderScreen(
          orderId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppRepository>.value(value: widget.repository),
        ChangeNotifierProvider<AuthController>.value(
          value: widget.authController,
        ),
      ],
      child: MaterialApp.router(
        title: 'Build Service',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}

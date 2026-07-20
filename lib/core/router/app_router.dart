import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/verify_phone_screen.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/refer/refer_screen.dart';
import '../../screens/tasks/tasks_screen.dart';
import '../../screens/wallet/wallet_screen.dart';
import '../../shared/widgets/main_bottom_nav.dart';

/// The 5 core tabs live under one StatefulShellRoute so MainBottomNav stays
/// mounted (and each tab keeps its own scroll/provider state) across tab
/// switches, instead of being rebuilt like a plain push route would be.
///
/// `/welcome`, `/register`, and `/login` are a separate, disconnected
/// pre-auth stack (PROJECT.md 6.1, Phase 3) — Welcome is the app's actual
/// entry point below, but there's no redirect logic wired between the two
/// stacks yet; that lands once the rest of Phase 3's auth screens exist.
final appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomeScreen(
        onCreateAccount: () => context.push('/register'),
        onLogIn: () => context.push('/login'),
      ),
    ),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/verify-phone',
      builder: (context, state) =>
          VerifyPhoneScreen(phoneNumber: state.extra as String? ?? ''),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: MainBottomNav(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/tasks', builder: (context, state) => const TasksScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/wallet', builder: (context, state) => const WalletScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/refer', builder: (context, state) => const ReferScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
          ],
        ),
      ],
    ),
  ],
);

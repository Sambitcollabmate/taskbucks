import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/verify_phone_screen.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/legal/privacy_screen.dart';
import '../../screens/legal/refund_screen.dart';
import '../../screens/legal/terms_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/refer/refer_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/support/support_tickets_screen.dart';
import '../../screens/tasks/tasks_screen.dart';
import '../../screens/transactions/transactions_screen.dart';
import '../../screens/trust/about_screen.dart';
import '../../screens/trust/contact_screen.dart';
import '../../screens/trust/faq_screen.dart';
import '../../screens/trust/how_it_works_screen.dart';
import '../../screens/trust/payment_proofs_screen.dart';
import '../../screens/upgrade/upgrade_screen.dart';
import '../../screens/wallet/wallet_screen.dart';
import '../../screens/withdraw/withdraw_screen.dart';
import '../../shared/widgets/main_bottom_nav.dart';

/// Single app-wide auth state (PROJECT.md 6.1) — also provided to the
/// widget tree in `main.dart` so Login/Verify Phone/Profile's log-out row
/// can call [AuthProvider.login]/[AuthProvider.logout]. Kept as one
/// top-level instance (rather than created inside a widget) so the
/// router's `redirect` callback and `refreshListenable` below can both
/// reference the same object.
final authProvider = AuthProvider();

const _preAuthPaths = {
  '/welcome',
  '/register',
  '/login',
  '/forgot-password',
  '/verify-phone',
};

/// Routes reachable regardless of auth state — trust/legal pages (PROJECT.md
/// Phase 5) are linked from both the pre-auth Welcome screen and the
/// post-auth Profile screen, so they must bypass the redirect below in both
/// directions rather than belonging to either the pre- or post-auth set.
const _publicPaths = {
  '/how-it-works',
  '/about',
  '/faq',
  '/contact',
  '/payment-proofs',
  '/terms',
  '/privacy',
  '/refund',
};

/// The 5 core tabs live under one StatefulShellRoute so MainBottomNav stays
/// mounted (and each tab keeps its own scroll/provider state) across tab
/// switches, instead of being rebuilt like a plain push route would be.
///
/// `redirect` + `refreshListenable` connect the pre-auth stack (`/welcome`,
/// `/register`, `/login`, `/forgot-password`, `/verify-phone`) to the
/// post-auth tab bar below (PROJECT.md 6.1): unauthenticated users get
/// bounced from any post-auth route to `/welcome`, authenticated users get
/// bounced from any pre-auth route to `/home`. `refreshListenable:
/// authProvider` means login()/logout() calling notifyListeners() re-runs
/// this check immediately, without every call site needing its own
/// `context.go`.
final appRouter = GoRouter(
  initialLocation: '/welcome',
  refreshListenable: authProvider,
  redirect: (context, state) {
    if (_publicPaths.contains(state.matchedLocation)) return null;
    final isLoggedIn = authProvider.isLoggedIn;
    final isPreAuthRoute = _preAuthPaths.contains(state.matchedLocation);
    if (!isLoggedIn && !isPreAuthRoute) return '/welcome';
    if (isLoggedIn && isPreAuthRoute) return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomeScreen(
        onCreateAccount: () => context.push('/register'),
        onLogIn: () => context.push('/login'),
      ),
    ),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(successMessage: state.extra as String?),
    ),
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
    GoRoute(
      path: '/transactions',
      builder: (context, state) =>
          TransactionsScreen(initialFilter: state.extra as TransactionFilter?),
    ),
    GoRoute(
      path: '/upgrade',
      builder: (context, state) => const UpgradeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) =>
          SettingsScreen(initialSection: state.extra as SettingsSection?),
    ),
    GoRoute(
      path: '/how-it-works',
      builder: (context, state) => const HowItWorksScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/faq',
      builder: (context, state) => const FaqScreen(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
    GoRoute(
      path: '/payment-proofs',
      builder: (context, state) => const PaymentProofsScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsScreen(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: '/refund',
      builder: (context, state) => const RefundScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/support-tickets',
      builder: (context, state) => const SupportTicketsScreen(),
    ),
    GoRoute(
      path: '/withdraw',
      builder: (context, state) => const WithdrawScreen(),
    ),
  ],
);

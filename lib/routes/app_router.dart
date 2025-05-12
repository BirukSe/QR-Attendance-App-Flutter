import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crossplatform_flutter/presentation/pages/auth/login_page.dart';
import 'package:crossplatform_flutter/presentation/pages/auth/signup_page.dart';
import 'package:crossplatform_flutter/presentation/pages/onboarding/splash_page.dart';

import 'package:crossplatform_flutter/presentation/pages/student/student_dashboard_page.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/student-dashboard',
      builder: (context, state) => const StudentDashboardPage(),
    ),
  
   
   
  ],
);

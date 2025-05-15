import 'package:crossplatform_flutter/presentation/pages/student/class_details_page.dart';
import 'package:crossplatform_flutter/presentation/pages/student/qr_scanning_page.dart';
import 'package:crossplatform_flutter/presentation/pages/teacher/section_detail_page.dart';
import 'package:crossplatform_flutter/presentation/pages/teacher/teacher_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crossplatform_flutter/presentation/pages/auth/login_page.dart';
import 'package:crossplatform_flutter/presentation/pages/auth/signup_page.dart';
import 'package:crossplatform_flutter/presentation/pages/onboarding/splash_page.dart';

import 'package:crossplatform_flutter/presentation/pages/student/student_dashboard_page.dart';
import 'package:crossplatform_flutter/presentation/pages/teacher/qr_display_page.dart';


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
     GoRoute(
      path: '/teacher-dashboard',
      builder: (context, state) => const TeacherDashboardPage(),
    ),
     GoRoute(
      path: '/section-detail/:courseId',
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;
        return SectionDetailPage(courseId: courseId);
      },
    ),
      GoRoute(
      path: '/qr-generator/:courseId',
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;
        return QrDisplayPage(courseId: courseId);
      },
    ),
    GoRoute(
      path: '/class-detail/:courseId/:courseName/:teacherName',
      builder: (context,state){
        final courseId=state.pathParameters['courseId'];
        final courseName=state.pathParameters['courseName'];
        final teacherName=state.pathParameters['teacherName'];
        return ClassDetailsPage(courseId: courseId!, courseName: courseName!, teacherName: teacherName!);
      }
      ),
      GoRoute(
        path: '/qr_scanner_page',
        builder: (context, state){
          return QrScanningPage();
        }
        )
  
   
   
  ],
);

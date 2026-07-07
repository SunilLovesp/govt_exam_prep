import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/main_screen.dart';
import '../../screens/exams/exam_list_screen.dart';
import '../../screens/exams/exam_detail_screen.dart';
import '../../screens/quiz/quiz_screen.dart';
import '../../screens/quiz/result_screen.dart';
import '../../screens/quiz/review_screen.dart';
import '../../screens/study_material/subject_list_screen.dart';
import '../../screens/study_material/topic_screen.dart';
import '../../screens/current_affairs/current_affairs_screen.dart';
import '../../screens/performance/performance_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/previous_years/pyq_list_screen.dart';
import '../../screens/previous_years/pdf_viewer_screen.dart';
import '../../screens/features/admin_tags_screen.dart';
import '../../screens/features/bookmarks_screen.dart';
import '../../screens/features/current_affairs_quiz_screen.dart';
import '../../screens/features/leaderboard_screen.dart';
import '../../screens/features/mock_analysis_screen.dart';
import '../../screens/features/notifications_screen.dart';
import '../../screens/features/offline_screen.dart';
import '../../screens/features/premium_screen.dart';
import '../../screens/features/prep_tools_screen.dart';
import '../../screens/features/study_plan_screen.dart';
import '../../screens/features/weak_area_screen.dart';
import '../../models/quiz_result.dart';
import '../../services/pyq_service.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String examList = '/exams';
  static const String examDetail = '/exams/:examId';
  static const String quiz = '/quiz/:testId';
  static const String result = '/result';
  static const String review = '/review';
  static const String studyMaterial = '/study-material';
  static const String topic = '/study-material/topic';
  static const String currentAffairs = '/current-affairs';
  static const String performance = '/performance';
  static const String profile = '/profile';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(
          path: 'exams',
          builder: (context, state) => const ExamListScreen(),
        ),
        GoRoute(
          path: 'exams/:examId',
          builder: (context, state) {
            final examId = state.pathParameters['examId']!;
            return ExamDetailScreen(examId: examId);
          },
        ),
        GoRoute(
          path: 'quiz/:testId',
          builder: (context, state) {
            final testId = state.pathParameters['testId']!;
            return QuizScreen(testId: testId);
          },
        ),
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final result = state.extra as QuizResult;
            return ResultScreen(result: result);
          },
        ),
        GoRoute(
          path: 'review',
          builder: (context, state) {
            final result = state.extra as QuizResult;
            return ReviewScreen(result: result);
          },
        ),
        GoRoute(
          path: 'study-material',
          builder: (context, state) => const SubjectListScreen(),
        ),
        GoRoute(
          path: 'study-material/topic',
          builder: (context, state) {
            final args = state.extra as Map<String, String>;
            return TopicScreen(subject: args['subject']!, chapter: args['chapter']!);
          },
        ),
        GoRoute(
          path: 'current-affairs',
          builder: (context, state) => const CurrentAffairsScreen(),
        ),
        GoRoute(
          path: 'performance',
          builder: (context, state) => const PerformanceScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'pyq',
          builder: (context, state) => const PYQListScreen(),
        ),
        GoRoute(
          path: 'pyq/viewer',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            return PDFViewerScreen(paper: args['paper'] as PYQPaper);
          },
        ),
        GoRoute(
          path: 'tools',
          builder: (context, state) => const PrepToolsScreen(),
        ),
        GoRoute(
          path: 'tools/study-plan',
          builder: (context, state) => const StudyPlanScreen(),
        ),
        GoRoute(
          path: 'tools/bookmarks',
          builder: (context, state) => const BookmarksScreen(),
        ),
        GoRoute(
          path: 'tools/weak-areas',
          builder: (context, state) => const WeakAreaScreen(),
        ),
        GoRoute(
          path: 'tools/mock-analysis',
          builder: (context, state) => const MockAnalysisScreen(),
        ),
        GoRoute(
          path: 'tools/current-affairs-quiz',
          builder: (context, state) => const CurrentAffairsQuizScreen(),
        ),
        GoRoute(
          path: 'tools/leaderboard',
          builder: (context, state) => const LeaderboardScreen(),
        ),
        GoRoute(
          path: 'tools/premium',
          builder: (context, state) => const PremiumScreen(),
        ),
        GoRoute(
          path: 'tools/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: 'tools/offline',
          builder: (context, state) => const OfflineScreen(),
        ),
        GoRoute(
          path: 'tools/admin-tags',
          builder: (context, state) => const AdminTagsScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);

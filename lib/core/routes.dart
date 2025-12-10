import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gradtrack/core/custom_app_bar.dart';
import 'package:gradtrack/core/custom_std_navbar.dart';
import 'package:gradtrack/core/custom_sup_navbar.dart';
import 'package:gradtrack/core/shared_preferences.dart';
import 'package:gradtrack/screens/auth/login/student_login.dart';
import 'package:gradtrack/screens/auth/login/supervisor_login.dart';
import 'package:gradtrack/screens/auth/model/group_model.dart';
import 'package:gradtrack/screens/auth/model/user_model.dart';
import 'package:gradtrack/screens/all_groups/std_chat_view.dart';
import 'package:gradtrack/screens/all_groups/sup_chat_view.dart';
import 'package:gradtrack/screens/chat/view/group_chat_view.dart';
import 'package:gradtrack/screens/create%20group/create_group_view.dart';
import 'package:gradtrack/screens/home/student_home.dart';
import 'package:gradtrack/screens/home/supervisor_home.dart';
import 'package:gradtrack/screens/profile/std_profile.dart';
import 'package:gradtrack/screens/profile/sup_profile_view.dart';
import 'package:gradtrack/screens/splash/splash_view.dart';
import 'package:gradtrack/screens/splash/welcome_view.dart';

abstract class AppRoutes {
  static const kSplashView = '/';
  static const kWelcomeView = '/welcome';
  static const kStdChatView = '/stdchat';
  static const kStdLoginView = '/stdlogin';
  static const kSupProfileView = '/supprofile';
  static const kSupLoginView = '/suplogin';
  static const kSupChatView = '/supchat';
  static const kStdProfileView = '/stdprofile';
  static const kstdHomeView = '/stdhome';
  static const kGroupView = '/group';
  static const kSupHomeView = '/suphome';
static const kSupGroupChat='/kgroupchat';
static String get savedRole=>CacheHelper.getData(key: 'role');
  static GoRouter getRouter({required bool isLoggedIn}) {
    return GoRouter(
   initialLocation: isLoggedIn && savedRole == 'student'
    ? kstdHomeView
    : isLoggedIn && savedRole == 'supervisor'
        ? kSupHomeView
        : kSplashView,

      routes: [
        // ==================== Public Routes ====================
        animatedRoute(
          path: kSplashView,
          builder: (context, state) => const SplashView(),
        ),
        animatedRoute(
          path: kWelcomeView,
          builder: (context, state) => const WelcomeView(),
        ),
        animatedRoute(
          path: kStdLoginView,
          builder: (context, state) => StudentLogin(),
        ),
        animatedRoute(
          path: kSupLoginView,
          builder: (context, state) => SupervisorLogin(),
        ),
         animatedRoute(
          path: kSupGroupChat,
          builder: (context, state) { 
             final group = state.extra as GroupModel;
          return  GroupChatView(groupModel: group,);}
        ),

        // ==================== Supervisor Screens ====================
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: SafeArea(child: CustomAppBar()),
              ),
              body: child,
              bottomNavigationBar: const CustomSupBottomNav(),
            );
          },
          routes: [
            animatedRoute(
              path: kSupHomeView,
               builder: (context, state) {
               
                return SupervisorHome();
              },
            ),
            animatedRoute(
              path: kGroupView,
              builder: (context, state) =>  CreateGroupView(),
            ),
            
            animatedRoute(
              path: kSupChatView,
              builder: (context, state) => AllGroupsView(),
            ),
            animatedRoute(
              path: kSupProfileView,
              builder: (context, state) => const SupProfileView(),
            ),
          ],
        ),

        // ==================== Student Screens ====================
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: SafeArea(child: CustomAppBar()),
              ),
              body: child,
              bottomNavigationBar: const CustomStdBottomNav(),
            );
          },
          routes: [
            animatedRoute(
              path: kstdHomeView,
              builder: (context, state) {
                final user = state.extra as UserModel;
                return StudentHome(user: user);
              },
            ),
            animatedRoute(
              path: kStdChatView,
              builder: (context, state) => StdChatView(),
            ),
            animatedRoute(
              path: kStdProfileView,
              builder: (context, state) => const StdProfile(),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== Animation Wrap ====================
  static GoRoute animatedRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 450),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          );
        },
        child: builder(context, state),
      ),
    );
  }
}

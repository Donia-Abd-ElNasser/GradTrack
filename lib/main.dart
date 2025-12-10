import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/core/routes.dart';
import 'package:gradtrack/core/shared_preferences.dart';
import 'package:gradtrack/firebase_options.dart';
import 'package:gradtrack/screens/all_groups/group_creation/group_creation_cubit.dart';
import 'package:gradtrack/screens/auth/auth_cubit/auth_cubit.dart';
import 'package:gradtrack/screens/chat/messages_cubit/messages_cubit.dart';
import 'package:gradtrack/screens/create%20group/all_student_cubit/all_student_cubit.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
     await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
String? userId = CacheHelper.getData(key: 'userId');
  bool isLoggedIn = userId != null;

runApp(
MultiBlocProvider(
  providers: [
BlocProvider(create: (context)=>AuthCubit()),
BlocProvider(create: (context)=>AllStudentCubit()),
BlocProvider(create: (context)=>GroupCreationCubit()),
BlocProvider(create: (context)=>MessagesCubit()),

  ],
  
  child:   GradTrack(isLoggedIn:isLoggedIn)),);
 
}
class GradTrack extends StatelessWidget {
  const GradTrack({super.key, required this.isLoggedIn});
 final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.getRouter(isLoggedIn:isLoggedIn),
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
       // scaffoldBackgroundColor: kPrimaryColor,
        fontFamily: kPrimaryFont,
      ),
    );
  }
}

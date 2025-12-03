import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/core/routes.dart';
import 'package:gradtrack/firebase_options.dart';
import 'package:gradtrack/screens/all_chats/group_creation/group_creation_cubit.dart';
import 'package:gradtrack/screens/auth/auth_cubit/auth_cubit.dart';
import 'package:gradtrack/screens/chat/messages_cubit%5D/messages_cubit.dart';
import 'package:gradtrack/screens/group/all_student_cubit/all_student_cubit.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);runApp(
MultiBlocProvider(
  providers: [
BlocProvider(create: (context)=>AuthCubit()),
BlocProvider(create: (context)=>AllStudentCubit()),
BlocProvider(create: (context)=>GroupCreationCubit()),
BlocProvider(create: (context)=>MessagesCubit()),

  ],
  
  child:  const GradTrack()),);
 
}
class GradTrack extends StatelessWidget {
  const GradTrack({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.getRouter(),
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
       // scaffoldBackgroundColor: kPrimaryColor,
        fontFamily: kPrimaryFont,
      ),
    );
  }
}

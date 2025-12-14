import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gradtrack/core/routes.dart';
import 'package:gradtrack/screens/auth/auth_cubit/auth_cubit.dart';

class SupervisorLogin extends StatelessWidget {
  SupervisorLogin({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errmssg)));
        }
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.black87)),
          );
        }

        if (state is AuthSuccess) {
          Navigator.pop(context);
          GoRouter.of(
            context,
          ).pushReplacement(AppRoutes.kSupHomeView, extra: state.userModel);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3B82F6), // blue-500
                  Color(0xFF06B6D4), // cyan-500
                  Color(0xFF2563EB), // blue-600
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 240),
                    SizedBox(height: height * 0.015),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: width * 0.13,
                          height: width * 0.13,
                          child: IconButton(
                            onPressed: () {
                              (context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.2),

                    /// Title
                    const Text(
                      "Supervisor Login",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// ----------- Name Field (Arabic) -----------
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black87, width: 1),
                      ),
                      child: TextFormField(
                        controller: nameController,
                        validator: (data) {
                          if (data!.isEmpty) {
                            return 'Supervisor\'s Name is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_rounded,
                            color: Colors.black87,
                          ),
                          hintText: "Name",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// ----------- Phone Field -----------
                   
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black87, width: 1),
                      ),
                      child: TextFormField(
                        controller: phoneController,
                        validator: (data) {
                          if (data!.isEmpty) {
                            return 'Supervisor\'s Phone number is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_rounded,
                            color: Colors.black87,
                          ),
                          hintText: "Phone Number",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    /// ----------- Login Button -----------
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          final phone = phoneController.text.trim();
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter your name"),
                              ),
                            );
                            return;
                          }

                          if (phone.isEmpty) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter your phone number"),
                              ),
                            );
                            return;
                          }
                          BlocProvider.of<AuthCubit>(
                            context,
                          ).loginSupervisor(name: name, phone: phone);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

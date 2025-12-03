import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/core/routes.dart';

class StdProfile extends StatelessWidget {
  const StdProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
      
              // ================= Profile Image ================
              Center(
                child: CircleAvatar(
                  radius: width * 0.18,
                  backgroundColor: Colors.black,
                 // backgroundImage: AssetImage("assets/images/profile.png"),
                ),
              ),
      
              const SizedBox(height: 15),
      
              // ================= Name =========================
              Text(
                "Student Name",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
      
              const SizedBox(height: 5),
      
              // ================= Phone ========================
              Text(
                "+20 01012345678",
                style: TextStyle(
                  fontSize: width * 0.045,
                  color: Colors.white70,
                ),
              ),
      
              const SizedBox(height: 15),
      
          
      
              // ================= Card: Account Info ============
              ProfileCard(
                title: "Account Information",
                icon: FontAwesomeIcons.circleUser,
                children: [
                  ProfileTile(label: "Role", value: "Student"),
                  ProfileTile(label: "Students Assigned", value: "25 Students"),
                  ProfileTile(label: "Groups Managed", value: "4"),
                ],
              ),
      
              const SizedBox(height: 20),
      
              // ================= Card: Settings ================
              ProfileCard(
                title: "Settings",
                icon: FontAwesomeIcons.gear,
                children: [
                  SettingsTile(
                    title: "Change Password",
                    icon: Icons.lock,
                    onTap: () {},
                  ),
                  SettingsTile(
                    title: "Logout",
                    icon: Icons.logout,
                    iconColor: Colors.red,
                    onTap: () {
                      GoRouter.of(context).pushReplacement(AppRoutes.kWelcomeView);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
//                    COMPONENTS
// ==========================================================

class ProfileCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const ProfileCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient:   LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: kGradient
                  ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.black87),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String label;
  final String value;

  const ProfileTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? Colors.black87),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

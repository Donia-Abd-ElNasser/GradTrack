// lib/screens/about_app/view/about_app_screen.dart
import 'package:flutter/material.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/screens/profile/profile_back_button.dart';


class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      
        title: CustomProfileBackButon(width: width, text: 'About')
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header
            _buildAppHeader(),
            const SizedBox(height: 30),
        
            // Features Section
            _buildFeaturesSection(),
            const SizedBox(height: 30),
        
            // App Info
            _buildAppInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: kGradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:  Colors.black87,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'GradTrack',
            style: TextStyle(
              color:  Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Smart Graduation Projects Manager',
            style: TextStyle(color:  Colors.black87, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Version 1.0.0',
            style: TextStyle(color:  Colors.black87, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'App Features',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
          gradient: LinearGradient(colors: kGradient),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildFeatureItem(
                icon: Icons.analytics,
                   title: 'Notifications & Alerts',
      description: 'Receive timely updates about deadlines and announcements',
              ),
              const SizedBox(height: 15),
              _buildFeatureItem(
                icon: Icons.pie_chart,
                title: 'Project Management',
      description: 'View, submit, and manage all Project Updates'
              ),
              const SizedBox(height: 15),
              _buildFeatureItem(
                icon: Icons.notifications,
                title: 'Smart Alerts',
                description: 'Get notified about your New Messages',
              ),
              const SizedBox(height: 15),
              _buildFeatureItem(
                icon: Icons.security,
                title: 'Secure Data',
                description: 'Your Personal data is safe and private',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color:  Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color:  Colors.black87, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: kGradient),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Information',
            style: TextStyle(
              color:  Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildInfoItem('Developer', 'GradTrack Team'),
          _buildInfoItem('Release Date', 'December 2025'),
          _buildInfoItem('Platform', 'Android & iOS'),
          _buildInfoItem('Privacy Policy', 'View Policy'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color:  Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
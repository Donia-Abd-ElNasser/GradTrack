// lib/screens/assistance/view/assistance_screen.dart
import 'package:flutter/material.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/screens/profile/profile_back_button.dart';


class AssistanceScreen extends StatelessWidget {
  const AssistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      
        title: CustomProfileBackButon(width: width, text: 'Ai Assistant')
      ),
      body: Column(
        children: [
          // Assistant Header
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: kGradient),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color:  Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GradTrack AI Assistant',
                        style: TextStyle(
                          color:  Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Ready to help with your Technical questions',
                        style: TextStyle(
                          color:  Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Help',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickAction(
                        icon: Icons.savings,
                        title: 'Technical Tips',
                        onTap: () {



                        },
                      ),  const SizedBox(width: 10),_buildQuickAction(
                        icon: Icons.security,
                        title: 'Security',
                        onTap: () {},
                      ),
                      const SizedBox(width: 10),
                      _buildQuickAction(
                        icon: Icons.trending_up,
                        title: 'Tracking',
                        onTap: () {},
                      ),
                      const SizedBox(width: 10),
                      _buildQuickAction(
                        icon: Icons.payment,
                        title: 'Dept Help',
                        onTap: () {},
                      ),
                     
                     
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Common Questions
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: kGradient),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      children: [
                       _buildQuestionItem(
        question: "How to create a new project?",
        answer:
            "Go to the Projects section, click 'New Project', fill in the required details, and submit it for approval.",
      ),
      _buildQuestionItem(
        question: "How to update project progress?",
        answer:
            "Open your project dashboard, update the progress status, add notes or files, and save changes.",
      ),
      _buildQuestionItem(
        question: "How to get feedback from supervisors?",
        answer:
            "Supervisors can leave comments on your project dashboard. Check the 'Feedback' tab regularly to view them.",
      ),
      _buildQuestionItem(
        question: "How to track submission deadlines?",
        answer:
            "All project milestones and deadlines are listed in the project timeline. You will also get notifications for upcoming deadlines.",
      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Start Chat Button
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to chat interface
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Start Chat with Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              color: Color.fromARGB(255, 59, 59, 59),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
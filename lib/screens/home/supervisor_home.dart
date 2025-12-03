import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/screens/auth/model/user_model.dart';
import 'package:gradtrack/screens/home/feedback_card.dart';
 // <-- add this package for graph

class SupervisorHome extends StatelessWidget {
  const SupervisorHome({super.key, required this.user});
final UserModel user;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:  Colors.white, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Container(
                width: width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: kGradient
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "Welcome Dr ${user.name} 👋",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Teams Completed their Missions",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(height: 14),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: 0.5,
                        minHeight: 10,
                        color: Colors.white,
                        backgroundColor: Colors.white30,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "50% Complete",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ===========================
              ///       INFO CARDS
              /// ===========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoCard(
                    icon: Icons.star_border_rounded,
                    title: "Rating",
                    value: "8.5",
                  ),
                  _infoCard(
                    icon: Icons.group_outlined,
                    title: "Team",
                    value: "3",
                  ),
                  _infoCard(
                    icon: Icons.flash_on_outlined,
                    title: "Active",
                    value: "2",
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// ===========================
              ///    PROGRESS OVERVIEW
              /// ===========================
              Container(
                width: width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                 gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: kGradient
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Progress Overview",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 18),

                    SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.cyanAccent,
                              dotData: FlDotData(show: true),
                              spots: const [
                                FlSpot(0, 1),
                                FlSpot(1, 2),
                                FlSpot(2, 3),
                                FlSpot(3, 3),
                                FlSpot(4, 3.4),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
             SizedBox(height: 5,),
                    FeedbackCard(
      title: user.t1,
      subtitle: "Excellent work!",
      rating: 8.5,
    ),
    FeedbackCard(
      title: user.t2,
      subtitle: "Outstanding choice",
      rating: 9,
    ),
    FeedbackCard(
      title: user.t3,
      subtitle: "Amazing performance",
      rating: 10,
    ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable small info card widget
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
       gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: kGradient
                  ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

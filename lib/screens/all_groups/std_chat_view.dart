import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradtrack/core/constants.dart';

class StdChatView extends StatelessWidget {
  StdChatView({super.key});

  final List<Map<String, dynamic>> groups = [
    {
      "name": "AI Graduation Project",
      "members": 4,
      "lastMsg": "Please upload your draft",
      "time": "10:45 AM",
    },
    {
      "name": "Mobile App Team",
      "members": 3,
      "lastMsg": "Great job yesterday!",
      "time": "09:10 AM",
    },
    {
      "name": "Data Science Group",
      "members": 5,
      "lastMsg": "Meeting at 8 PM",
      "time": "Yesterday",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔵 Title
              const Text(
                "Your Groups",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 18),

              // 🔍 Search
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search group...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📌 groups list
              ListView.builder(
                itemCount: groups.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final group = groups[index];

                  return GestureDetector(
                    onTap: () {
                      // هنا هتروحي للشات بتاع الجروب
                      // GoRouter.of(context).push(AppRoutes.kGroupChat);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: kGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          // 🎯 group icon
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.peopleGroup,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),

                          const SizedBox(width: 14),

                          // 🔵 group info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group["name"],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${group['members']} Members",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  group["lastMsg"],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ⏰ Time
                          Text(
                            group["time"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

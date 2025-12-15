import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradtrack/core/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 62,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(25),
        // gradient: const LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Color(0xFF3B82F6),
        //     Color(0xFF06B6D4),
        //     Color(0xFF2563EB),
        //   ],
        // ),
        color: Colors.white
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: kGradient
        ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              FontAwesomeIcons.graduationCap,
              color: Colors.black,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'GradTrack',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

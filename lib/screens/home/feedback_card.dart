import 'package:flutter/material.dart';
import 'package:gradtrack/core/constants.dart';

class FeedbackCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final double rating;

  const FeedbackCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rating,
  });

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  late double currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: kGradient),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Rating Badge
          GestureDetector(
            onTap: () => _showRatingDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xff4cc9f0),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    currentRating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) async {
    double tempRating = currentRating;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          "Rate the Team",
          style: TextStyle(color:Colors.white,fontWeight: FontWeight.w700),
        ),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(8, (index) {
                return GestureDetector(
                  onTap: () {
                    setStateDialog(() {
                      tempRating = index + 1.0;
                    });
                  },
                  child: Icon(
                    Icons.star_rounded,
                    color: index < tempRating ? Colors.amber : Colors.white,
                    size: 25,
                  ),
                );
              }),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                currentRating = tempRating;
              });
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(color:Colors.white,fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

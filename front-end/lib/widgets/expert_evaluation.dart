import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ExpertEvaluation extends StatefulWidget {
  const ExpertEvaluation({super.key});

  @override
  State<ExpertEvaluation> createState() => _ExpertEvaluationState();
}

class _ExpertEvaluationState extends State<ExpertEvaluation> {
  double rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          RatingBar.builder(
            minRating: 0.5,
            updateOnDrag: true,
            allowHalfRating: true,
            glowColor: Colors.amber,
            unratedColor: Colors.black54,
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              setState(() {
                this.rating = rating;
              });
            },
          ),
          const SizedBox(height: 30),
          Text(
            'Your rate: $rating',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            rating > 0.0 ? 'Thanks for rating me' : 'Please rate me',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

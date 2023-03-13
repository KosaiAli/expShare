import 'dart:convert';

import 'package:expshare/providers/experts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../https/config.dart';

class ExpertEvaluation extends StatefulWidget {
  const ExpertEvaluation({super.key, required this.id});
  final String id;
  @override
  State<ExpertEvaluation> createState() => _ExpertEvaluationState();
}

class _ExpertEvaluationState extends State<ExpertEvaluation> {
  double rating = 0.5;
  bool rated = false;
  void rate() async {
    if (rating == 0.0) {
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: const Text(
                'you have to rate with number bigger than 0 :)',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK!',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            );
          });
    }

    var url = Uri.http(Config.host, 'api/AddRate');
    var header = await Config.getHeader();
    http
        .post(url,
            headers: header,
            body: jsonEncode({'expert_id': widget.id, 'rate': rating}))
        .then((response) {
      var provider = Provider.of<Experts>(context, listen: false);

      if (response.statusCode == 200) {
        provider.getAllExperts();
      }
      showDialog(
          context: context,
          builder: (ctx) {
            String message;
            if (response.statusCode == 403) {
              message = provider.language == Language.english
                  ? 'You have already rated this expert'
                  : 'لقد قمت بالفعل بتصنيف هذا الخبير';
            } else {
              message = provider.language == Language.english
                  ? 'rated successfully'
                  : 'تم التقييم بنجاح';
            }
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                content: Text(
                  message,
                  style: const TextStyle(color: Colors.black),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        provider.language == Language.english ? 'OK!' : 'تم!',
                        style: const TextStyle(color: Colors.blue),
                      ))
                ],
              ),
            );
          });
      setState(() {
        rated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final expertProvider = Provider.of<Experts>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          IgnorePointer(
            ignoring: expertProvider.isExpert,
            child: RatingBar.builder(
              minRating: 0.5,
              initialRating:
                  expertProvider.isExpert ? expertProvider.user!.rate : rating,
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
          ),
          const SizedBox(height: 30),
          Text(
            !expertProvider.isExpert
                ? expertProvider.language == Language.english
                    ? 'Your rate: $rating'
                    : 'تقييمك: $rating'
                : 'My rate : ${expertProvider.user!.rate}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 30),
          if (!expertProvider.isExpert)
            TextButton(
              onPressed: rate,
              child: Text(
                rated
                    ? expertProvider.language == Language.english
                        ? 'Thanks for rating me'
                        : 'شكرا لك'
                    : expertProvider.language == Language.english
                        ? 'Please rate me'
                        : 'اضفط لاضافة تقييم',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

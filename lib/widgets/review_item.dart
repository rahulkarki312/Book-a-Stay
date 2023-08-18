import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/userReview.dart';

class ReviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ReviewDetails review = Provider.of<ReviewDetails>(context, listen: false);

    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
              title: Text('user: ${review.userId}'),
              subtitle: Text(review.review),
              trailing: Text(review.date.toString())),
        ],
      ),
    );
  }
}

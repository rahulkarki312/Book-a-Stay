import 'dart:math';

import 'package:book_a_stay/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/userReview.dart';
import '../providers/hotels.dart';

class ReviewItem extends StatelessWidget {
  final String hotelId;
  ReviewItem(this.hotelId);

  @override
  Widget build(BuildContext context) {
    ReviewDetails review = Provider.of<ReviewDetails>(context, listen: false);
    final currentUser = Provider.of<Auth>(context).userId;
    final reviewByUser = review.userId;
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
          title: Text('review: ${review.review}'),
          subtitle: Text(review.userId),
          trailing: Column(
            children: [
              Text(DateFormat.yMd().format(review.date)),
              if (currentUser == reviewByUser)
                IconButton(
                    onPressed: () => Provider.of<Hotels>(context, listen: false)
                        .removeReview(review.id, hotelId),
                    icon: const Icon(Icons.delete))
            ],
          )),
    );
  }
}

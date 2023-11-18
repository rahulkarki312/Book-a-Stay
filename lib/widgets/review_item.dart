import 'dart:math';

import 'package:book_a_stay/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/userReview.dart';
import '../providers/hotels.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewItem extends StatelessWidget {
  final String hotelId;
  bool? showOnly;
  ReviewItem({required this.hotelId, this.showOnly = false});

  @override
  Widget build(BuildContext context) {
    ReviewDetails review = Provider.of<ReviewDetails>(context);
    final currentUser = Provider.of<Auth>(context).userId;
    final reviewByUser = review.userId;
    return Container(
      constraints: BoxConstraints(
          maxWidth: showOnly!
              ? MediaQuery.of(context).size.width * 0.8
              : MediaQuery.of(context).size.width * 0.9),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                      fontSize: showOnly! ? 15 : 17,
                      color: Colors.black,
                      fontFamily: "Montserrat",
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: " ${review.username}: ",
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: review.review),
                    ],
                  ),
                ),
                // Text(
                //   '${review.username}: ${review.review}',
                //   style: TextStyle(fontSize: showOnly! ? 15 : 17),
                // ),
                RatingBarIndicator(
                  rating: review.rating,
                  itemBuilder: (ctx, idx) => Icon(
                    showOnly! ? Icons.circle : Icons.star,
                    color: showOnly! ? Colors.black : Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: showOnly! ? 15 : 20,
                  direction: Axis.horizontal,
                )
              ],
            ),
            subtitle:
                showOnly! ? null : Text(DateFormat.yMd().format(review.date)),
            trailing: showOnly!
                ? null
                : currentUser == reviewByUser
                    ? IconButton(
                        onPressed: () =>
                            Provider.of<Hotels>(context, listen: false)
                                .removeReview(review.id, hotelId),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                    : Container(
                        width: 0,
                        height: 0,
                      )),
      ),
    );
  }
}

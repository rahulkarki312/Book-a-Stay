import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel.dart';
import '../providers/userfilter.dart';
import '../providers/auth.dart';
import '../screens/booking_page.dart';

class UserHotelItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hotel = Provider.of<Hotel>(context);
    final isFavorite = hotel.isFavorite;
    final noOfDays = Provider.of<UserFilter>(context)
        .noOfDays; //no of days of stay set in filter by the user
    final auth = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(BookingPage.routename, arguments: hotel.id),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    // height: MediaQuery.of(context).size.height * 0.5,
                    // width: MediaQuery.of(context).size.width,
                    child: Image.network(
                  hotel.imageUrl,
                  fit: BoxFit.cover,
                )),
                Positioned(
                  bottom: 20,
                  child: Column(
                    children: [
                      Text(
                        hotel.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text("\$:  ${noOfDays * hotel.price}",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 5,
                    child: IconButton(
                      icon: isFavorite
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_border_outlined),
                      onPressed: () =>
                          Provider.of<Hotel>(context, listen: false)
                              .toggleFavoriteStatus(auth.token!, auth.userId!),
                    ))
              ],
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel.dart';
import '../providers/userfilter.dart';
import '../screens/booking_page.dart';

class UserHotelItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hotel = Provider.of<Hotel>(context);
    final noOfDays = Provider.of<UserFilter>(context)
        .noOfDays; //no of days of stay set in filter by the user
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
                )
              ],
            ),
          ],
        ));
  }
}

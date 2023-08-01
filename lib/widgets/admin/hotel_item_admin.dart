import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/admin/edit_hotels_screen.dart';
import '../../providers/hotel.dart';
import '../../providers/auth.dart';

class HotelItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hotel = Provider.of<Hotel>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          EditHotelScreen.routeName,
          arguments: hotel.id,
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.60,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Hero(
                tag: hotel.id,
                child: Image.network(
                  hotel.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Rs. ${hotel.price}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Text(
                      hotel.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel.dart';

class UserHotelItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hotel = Provider.of<Hotel>(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
              Text("\$: ")
            ],
          ),
        )
      ],
    );
  }
}

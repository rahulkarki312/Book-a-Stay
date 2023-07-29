import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel.dart';
import '../providers/hotels.dart';
import './hotel_item.dart';

class HotelsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HotelsData = Provider.of<Hotels>(context);
    final hotels = HotelsData.hotels;
    final hotelsLength = hotels.length;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: hotels.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: hotels[i],
        child: HotelItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

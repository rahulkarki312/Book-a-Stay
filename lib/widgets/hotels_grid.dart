import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hotel.dart';
import '../../providers/hotels.dart';
import 'hotel_item.dart';
import '../providers/userfilter.dart';

class HotelsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HotelsData = Provider.of<Hotels>(context);
    final location = Provider.of<UserFilter>(context).location;

    final hotels = location == null
        ? HotelsData.hotels
        : HotelsData.hotels
            .where((hotel) => hotel.address == location)
            .toList();
    // final hotels = HotelsData.hotels;
    // final hotelsLength = hotels.length;
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10.0),
      itemCount: hotels.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: hotels[i],
        child: UserHotelItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2.0,
        mainAxisSpacing: 10,
      ),
    );
  }
}

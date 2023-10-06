import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel.dart';
import '../providers/userfilter.dart';
import '../providers/auth.dart';
import '../screens/booking_page.dart';
import '../widgets/parallax_flow_delegate.dart';

class UserHotelItem extends StatelessWidget {
  final GlobalKey _backgroundImageKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // print("bulidHotelItemCalled");
    final hotel = Provider.of<Hotel>(context);
    print(hotel.reviews);
    final isFavorite = hotel.isFavorite;
    final noOfDays = Provider.of<UserFilter>(context)
        .noOfDays; //no of days of stay set in filter by the user
    final auth = Provider.of<Auth>(context, listen: false);

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(BookingPage.routename, arguments: hotel.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        child: AspectRatio(
          aspectRatio: 16 / 11,
          child: Stack(
            // alignment: Alignment.center,
            children: [
              _buildBackground(context, hotel.imageUrl),
              _buildGradient(),
              _buildTitle(hotel.title, noOfDays * hotel.price),
              Positioned(
                  top: 10,
                  right: 5,
                  child: IconButton(
                    icon: isFavorite
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border_outlined),
                    onPressed: () => Provider.of<Hotel>(context, listen: false)
                        .toggleFavoriteStatus(auth.token!, auth.userId!),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Functions for parallax effect
  Widget _buildBackground(BuildContext context, String imageUrl) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context)!,
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(
          imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String hotelName, num price) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hotelName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            price.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

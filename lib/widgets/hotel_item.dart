import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel.dart';
import '../providers/userfilter.dart';
import '../providers/auth.dart';
import '../screens/booking_page.dart';
import '../widgets/parallax_flow_delegate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserHotelItem extends StatefulWidget {
  @override
  State<UserHotelItem> createState() => _UserHotelItemState();
}

class _UserHotelItemState extends State<UserHotelItem> {
  late GlobalKey _backgroundImageKey;

  @override
  void initState() {
    super.initState();
    _backgroundImageKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    // print("bulidHotelItemCalled");
    final hotel = Provider.of<Hotel>(context);
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
          aspectRatio: 18 / 11,
          child: Stack(
            // alignment: Alignment.center,
            children: [
              _buildBackground(context, hotel.imageUrl),
              _buildGradient(),
              _buildTitle(
                  hotel.title,
                  noOfDays * hotel.price,
                  hotel.reviewsCount,
                  hotel.avgRating,
                  hotel.address,
                  hotel.breakfastIncl),
              // heart button
              Positioned(
                  top: 10,
                  right: 5,
                  child: Stack(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black, width: 0.6),
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        left: -4,
                        bottom: -4,
                        child: IconButton(
                          icon: isFavorite
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border_outlined,
                                ),
                          onPressed: () => Provider.of<Hotel>(context,
                                  listen: false)
                              .toggleFavoriteStatus(auth.token!, auth.userId!),
                        ),
                      ),
                    ],
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
        Container(
          child: Image.network(
            imageUrl,
            key: _backgroundImageKey,
            fit: BoxFit.cover,
          ),
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

  Widget _buildTitle(String hotelName, num price, int reviewsCount,
      double avgRating, String location, bool breakfastIncl) {
    return Positioned(
      left: 20,
      bottom: 15,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hotelName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(-2, -2),
                  )
                ]),
          ),
          Text(
            "Rs.${price.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              RatingBarIndicator(
                rating: avgRating,
                itemBuilder: (ctx, idx) => const Icon(
                  Icons.circle,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              Text(
                "  ( $reviewsCount )",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            "$location",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w200, fontSize: 15),
          ),
          if (breakfastIncl)
            const Text("Breakfast Included",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    fontSize: 15))
        ],
      ),
    );
  }
}

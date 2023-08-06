import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel.dart';
import '../providers/hotels.dart';
import '../providers/userfilter.dart';

class BookingPage extends StatefulWidget {
  static const routename = '/booking-page';
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late String hotelId;

  @override
  void didChangeDependencies() {
    var routedHotelId =
        ModalRoute.of(context)!.settings.arguments.toString() as String?;

    if (routedHotelId != null) {
      hotelId = routedHotelId;
    } else {
      Navigator.of(context).pop();
    }

    super.didChangeDependencies();
    // hotelId = '-NaRaHzl46xpQPOOCwsw';
    //4176000
  }

  @override
  Widget build(BuildContext context) {
    if (hotelId == null || hotelId == '') {
      Navigator.of(context).pop();
    }
    print("hotel id : $hotelId");
    Hotel hotel = Provider.of<Hotels>(context, listen: false).findById(hotelId);
    int noOfDays = Provider.of<UserFilter>(context, listen: false).noOfDays;
    int customerCount =
        Provider.of<UserFilter>(context, listen: false).customerCount;

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("Book ${hotel.title}")),
        body: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    // height: MediaQuery.of(context).size.height,
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
            TextButton(onPressed: () {}, child: Text("Book Now"))
          ],
        ));
  }
}

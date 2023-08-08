import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel.dart';
import '../providers/hotels.dart';
import '../providers/userfilter.dart';
import '../providers/orders.dart';
import '../providers/order.dart';
import '../providers/auth.dart';
import '../widgets/home_drawer.dart';

class BookingPage extends StatefulWidget {
  static const routename = '/booking-page';
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? hotelId;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var routedHotelId = ModalRoute.of(context)!.settings.arguments.toString();
    if (routedHotelId != null) {
      hotelId = routedHotelId;
    } else {
      Navigator.of(context).pop();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (hotelId == null) {
      Navigator.of(context).pop();
    }

    Hotel hotel = Provider.of<Hotels>(context, listen: false).findById(hotelId);
    DateTime checkInDay =
        Provider.of<UserFilter>(context, listen: false).checkInDay;
    DateTime checkOutDay =
        Provider.of<UserFilter>(context, listen: false).checkOutDay;
    int noOfDays = checkOutDay.difference(checkInDay).inDays;
    int customerCount =
        Provider.of<UserFilter>(context, listen: false).customerCount;

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("Book ${hotel.title}")),
        drawer: HomeDrawer(),
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
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: Colors.white,
                          ),
                          Text(
                            customerCount.toString(),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Text("\$:  ${noOfDays * hotel.price}",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                )
              ],
            ),
            _isLoading
                ? CircularProgressIndicator()
                : TextButton(
                    onPressed: () async {
                      print(
                          " userId: ${Provider.of<Auth>(context, listen: false).userId!}, checkInDay: $checkInDay, checkOutDay: $checkOutDay, price: ${noOfDays * hotel.price}");
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        await Provider.of<Orders>(context, listen: false)
                            .addOrder(Order(
                                id: "",
                                hotelId: hotelId!,
                                userId:
                                    Provider.of<Auth>(context, listen: false)
                                        .userId!,
                                checkInDay: checkInDay,
                                checkOutDay: checkOutDay,
                                customerCount: customerCount,
                                price: noOfDays * hotel.price))
                            .then((_) {
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 5),
                            content: Text(
                                "Hotel booked, happy stay ! You can see your orders in orders section in home page."),
                            action: SnackBarAction(
                              label: "ok",
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ));
                        });
                      } catch (error) {
                        await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text("An error occured !"),
                                  content: Text("Something went wrong!"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() => _isLoading = false);
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Okay"))
                                  ],
                                ));
                      }
                    },
                    child: Text("Book Now"))
          ],
        ));
  }
}

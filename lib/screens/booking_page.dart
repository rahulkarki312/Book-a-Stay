import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/hotel.dart';
import '../providers/hotels.dart';
import '../providers/userfilter.dart';
import '../providers/orders.dart';
import '../providers/order.dart';
import '../providers/auth.dart';
import '../widgets/home_drawer.dart';
import '../widgets/review_item.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../widgets/date_selector.dart';
import 'add_review_screen.dart';

class BookingPage extends StatefulWidget {
  static const routename = '/booking-page';
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? hotelId;
  bool _isOrderLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var routedHotelId = ModalRoute.of(context)!.settings.arguments.toString();
    if (routedHotelId != "null") {
      hotelId = routedHotelId;
    } else {
      Navigator.of(context).pop();
    }

    super.didChangeDependencies();
  }

  Future<void> _order() async {
    Hotel hotel = Provider.of<Hotels>(context, listen: false).findById(hotelId);
    DateTime checkInDay =
        Provider.of<UserFilter>(context, listen: false).checkInDay;
    DateTime checkOutDay =
        Provider.of<UserFilter>(context, listen: false).checkOutDay;
    int noOfDays = checkOutDay.difference(checkInDay).inDays;
    int customerCount =
        Provider.of<UserFilter>(context, listen: false).customerCount;
    setState(() {
      _isOrderLoading = true;
    });

    try {
      await Provider.of<Orders>(context, listen: false)
          .addOrder(Order(
              id: "",
              hotelId: hotelId!,
              userId: Provider.of<Auth>(context, listen: false).userId!,
              checkInDay: checkInDay,
              checkOutDay: checkOutDay,
              customerCount: customerCount,
              price: noOfDays * hotel.price))
          .then((_) {
        setState(() => _isOrderLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 5),
          content: const Text(
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
                title: const Text("An error occured !"),
                content: const Text("Something went wrong!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() => _isOrderLoading = false);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Okay"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Hotel hotel = Provider.of<Hotels>(context).findById(hotelId);
    DateTime checkInDay =
        Provider.of<UserFilter>(context, listen: false).checkInDay;
    DateTime checkOutDay =
        Provider.of<UserFilter>(context, listen: false).checkOutDay;
    int noOfDays = checkOutDay.difference(checkInDay).inDays;
    int customerCount =
        Provider.of<UserFilter>(context, listen: false).customerCount;

    return Scaffold(
        appBar: AppBar(
          title: Text("Book ${hotel.title}"),
          actions: [
            TextButton(
              child: const Icon(
                Icons.arrow_left_sharp,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
        drawer: HomeDrawer(),
        body: ListView(
          children: [
            // Image
            Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  hotel.imageUrl,
                  fit: BoxFit.cover,
                )),

            // hotel description
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hotel.avgRating > 4)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Text(
                        "TOP RATED",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  Text(
                    hotel.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: hotel.avgRating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.circle,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      Text(
                        "   ${hotel.reviewsCount} reviews",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                  // about hotel section
                  Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 2),
                      child: Text(hotel.description)),
                  // Booking info part
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                        constraints:
                            const BoxConstraints(minHeight: 65, maxHeight: 300),
                        context: context,
                        builder: (ctx) => Column(
                              children: [
                                const SizedBox(height: 15),
                                const Text(
                                  "Change Your Reservation Filter",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                const SizedBox(height: 15),
                                DateSelector(
                                  showLocationFilter: false,
                                ),
                              ],
                            )).then((_) => setState(() {})),
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 15,
                            ),
                            Text(
                              " ${DateFormat.MMMd().format(checkInDay)} -> ${DateFormat.MMMd().format(checkOutDay)}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                            const Icon(
                              Icons.people_outline,
                              size: 15,
                            ),
                            Text(" $customerCount",
                                style: const TextStyle(fontSize: 15))
                          ],
                        )),
                  ),

                  _isOrderLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        onPressed: () {},
                                        child: const Text(
                                          'Confirm Booking',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        )),
                                    content: Text(
                                      'Do you want to book an order at ${hotel.title}? \n Check In : ${DateFormat.yMMMEd().format(checkInDay)} \n Check Out: ${DateFormat.yMMMEd().format(checkOutDay)} \n people: $customerCount \n Total price: ${noOfDays * hotel.price} ',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                          ),
                                          onPressed: () {
                                            _order();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Confirm',
                                          )),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Book Now",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.black)),
                        child: const Text("Write a Review"),
                        onPressed: () => Navigator.of(context).pushNamed(
                            AddReviewScreen.routeName,
                            arguments: hotelId)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Center(child: Text("${hotel.reviewsCount} reviews")),
            // hotel reviews section
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              itemCount: hotel.reviews.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: hotel.reviews[i],
                child: ReviewItem(hotelId: hotelId!),
              ),
            ),
          ],
        ));
  }
}

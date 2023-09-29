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
import '../providers/userReview.dart';

class BookingPage extends StatefulWidget {
  static const routename = '/booking-page';
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? hotelId;
  bool _isOrderLoading = false;
  bool _reviewFormIsLoading = false;
  final _reviewNode = FocusNode();
  final _ratingNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  final _ratingController = TextEditingController();

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
                title: Text("An error occured !"),
                content: Text("Something went wrong!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() => _isOrderLoading = false);
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Okay"))
                ],
              ));
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _reviewFormIsLoading = true;
    });
    Provider.of<Hotels>(context, listen: false)
        .addReview(
            _reviewController.text, int.parse(_ratingController.text), hotelId!)
        .then((value) {
      setState(() {
        _reviewFormIsLoading = false;
      });
      _reviewController.clear();
      _ratingController.clear();
    });
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
                        style: const TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            color: Colors.white,
                          ),
                          Text(
                            customerCount.toString(),
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Text("\$:  ${noOfDays * hotel.price}",
                          style: const TextStyle(color: Colors.white))
                    ],
                  ),
                )
              ],
            ),
            _isOrderLoading
                ? const Center(child: const CircularProgressIndicator())
                : TextButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Booking'),
                            content: Text(
                              'Do you want to book an order at ${hotel.title}? \n Check In : ${DateFormat.yMMMEd().format(checkInDay)} \n Check Out: ${DateFormat.yMMMEd().format(checkOutDay)} \n people: $customerCount \n Total price: ${noOfDays * hotel.price} ',
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Confirm'),
                                onPressed: () {
                                  _order();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Book Now",
                      style: TextStyle(color: Colors.black),
                    )),
            const SizedBox(height: 20),
            const Text('Write a review'),
            Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _reviewController,
                      focusNode: _reviewNode,
                      decoration: const InputDecoration(labelText: 'Review'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_ratingNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Review';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ratingController,
                      focusNode: _ratingNode,
                      decoration: const InputDecoration(labelText: 'rating'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please give some rating';
                        }
                        return null;
                      },
                    ),
                    _reviewFormIsLoading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: _saveForm, child: const Text("submit"))
                  ],
                )),

            // hotel reviews section
            FutureBuilder(
              future: Provider.of<Hotels>(context, listen: false)
                  .fetchAndSetReviews(hotelId!),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    print(
                        'orders_screen :An error occurred! ${dataSnapshot.error.toString()}');
                    // Do error handling stuff
                    return const Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Consumer<Hotels>(
                      builder: (ctx, hotels, child) => hotels.reviews.isEmpty
                          ? const Card(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("No Reviews Yet.."),
                                    Icon(Icons.reviews_outlined)
                                  ]),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(10.0),
                              itemCount: hotels.reviews.length,
                              itemBuilder: (ctx, i) =>
                                  ChangeNotifierProvider.value(
                                value: hotels.reviews[i],
                                child: ReviewItem(hotelId!),
                              ),
                            ),
                    );
                  }
                }
              },
            ),
          ],
        ));
  }
}

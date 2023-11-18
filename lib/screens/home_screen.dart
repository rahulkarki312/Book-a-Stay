import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../providers/hotels.dart';
import '../providers/hotel.dart';
import '../widgets/hotel_item.dart';
import 'package:provider/provider.dart';
import '../widgets/date_selector.dart';
import '../providers/auth.dart';
import '../widgets/home_drawer.dart';
import '../widgets/hotels_grid.dart';
import '../providers/userfilter.dart';

const Color darkRed = Color.fromARGB(255, 18, 32, 47);

class HomeScreen extends StatefulWidget {
  static const routename = "/home-screen";
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Hotels>(context, listen: false)
        .fetchAndSetHotels()
        .then((value) {
      setState(() => _isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hotelsData = Provider.of<Hotels>(context);
    final location = Provider.of<UserFilter>(context).location;

    // filtering hotels

    final hotels = location == null
        ? hotelsData.hotels
        : hotelsData.hotels
            .where((hotel) => hotel.address == location)
            .toList();

    return Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(
          foregroundColor: Theme.of(context).primaryColor,
          title: const Text("Home Page"),
          actions: [],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  DateSelector(),
                  for (final hotel in hotels)
                    ChangeNotifierProvider.value(
                        value: hotel, child: UserHotelItem())
                  // HotelsGrid(),
                ],
              ));
  }
}

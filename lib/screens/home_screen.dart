import 'package:book_a_stay/widgets/hotels_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/hotels.dart';
import '../providers/hotel.dart';
import '../widgets/date_selector.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = true;

  @override
  void initState() {
    setState(() => _isLoading = true);
    Provider.of<Hotels>(context, listen: false)
        .fetchAndSetHotels()
        .then((value) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          TextButton(
              onPressed: () => Provider.of<Auth>(context).logout(),
              child: Text(
                'Log out',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  DateSelector(),
                  HotelsGrid(),
                ],
              ),
            ),
    );
  }
}

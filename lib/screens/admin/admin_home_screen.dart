import 'package:book_a_stay/widgets/admin/hotels_grid_admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../providers/hotels.dart';
import './edit_hotels_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  var _isLoading = true;

  @override
  void initState() {
    // setState(() => _isLoading = true);

    Provider.of<Hotels>(context, listen: false).fetchAndSetHotels().then((_) {
      print("Hotels fetched and set");
      setState(() => _isLoading = false);
    });
    // print("Hotels fetched and set");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("Admin Screen"), actions: [
          TextButton(
              onPressed: () =>
                  Provider.of<Auth>(context, listen: false).logout(),
              child: Text(
                "Log out",
                style: TextStyle(color: Colors.white),
              )),
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditHotelScreen.routeName),
              icon: Icon(Icons.add)),
        ]),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : HotelsGridAdmin());
  }
}

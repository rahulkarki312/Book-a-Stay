import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import './edit_hotels_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Admin Screen"), actions: [
        IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditHotelScreen.routeName),
            icon: Icon(Icons.add))
      ]),
      body: Center(
          child: TextButton(
        child: Text("Log out"),
        onPressed: () {
          Provider.of<Auth>(context, listen: false).logout();
        },
      )),
    );
  }
}

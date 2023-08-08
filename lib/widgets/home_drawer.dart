import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(children: [
        TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(OrdersScreen.routeName),
            child: Text("Orders"))
      ]),
    );
  }
}

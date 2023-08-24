import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/users_favorites_screen.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(children: [
        TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(OrdersScreen.routeName),
            child: Text("Orders")),
        TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(UsersFavoritesScreen.RouteName),
            child: Text("Your Favorites"))
      ]),
    );
  }
}

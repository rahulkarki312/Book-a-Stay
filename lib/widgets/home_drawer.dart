import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/orders_screen.dart';
import '../screens/users_favorites_screen.dart';
import '../providers/auth.dart';
import '../screens/add_review_screen.dart';
import '../screens/select_hotel_screen.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: ListView(children: [
        TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(OrdersScreen.routeName),
            child: const Text("Orders")),
        TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(UsersFavoritesScreen.RouteName),
            child: const Text("Your Favorites")),
        TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(SelectHotelScreen.routename),
            child: const Text("Write Review")),
        TextButton(
            onPressed: () => Provider.of<Auth>(context, listen: false).logout(),
            child: const Text(
              'Log out',
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
        ),
      ]),
    );
  }
}

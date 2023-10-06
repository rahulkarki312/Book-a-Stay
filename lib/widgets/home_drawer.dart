import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/orders_screen.dart';
import '../screens/users_favorites_screen.dart';
import '../providers/auth.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            onPressed: () => Provider.of<Auth>(context, listen: false).logout(),
            child: const Text(
              'Log out',
            )),
        Consumer<Auth>(
          builder: (context, auth, child) => Text(auth.username!),
        )
      ]),
    );
  }
}

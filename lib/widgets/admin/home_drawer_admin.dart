import 'package:flutter/material.dart';
import '../../screens/admin/orders_screen_admin.dart';

class HomeDrawerAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(OrdersScreenAdmin.routeName),
            child: const Text("Orders"))
      ]),
    );
  }
}

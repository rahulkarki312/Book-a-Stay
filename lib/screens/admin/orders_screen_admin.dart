import 'package:book_a_stay/widgets/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders.dart' show Orders;
// OrderItem from providers is not needed since only the data is needed here

import '../../widgets/order_item.dart';
import '../../widgets/admin/home_drawer_admin.dart';

class OrdersScreenAdmin extends StatelessWidget {
  static const routeName = '/orders_screen_admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Orders'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_sharp))
        ],
      ),
      drawer: HomeDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false)
            .fetchAndSetOrders(isAdmin: true),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              print('orders_screen :An error occurred! ' +
                  dataSnapshot.error.toString());
              // Do error handling stuff
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

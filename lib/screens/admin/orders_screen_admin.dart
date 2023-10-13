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
    print('building orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Orders'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_sharp))
        ],
      ),
      drawer: HomeDrawerAdmin(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              print('orders_screen :An error occurred! ' +
                  dataSnapshot.error.toString());
              // Do error handling stuff
              return Center(
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

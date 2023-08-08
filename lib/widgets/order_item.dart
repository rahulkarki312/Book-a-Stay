import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/order.dart';
import '../providers/hotel.dart';
import '../providers/hotels.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final Hotel bookedHotel = Provider.of<Hotels>(context, listen: false)
        .findById(widget.order.hotelId);

    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${bookedHotel.title}  \$${widget.order.price}'),
            subtitle: Text(
              "${widget.order.checkOutDay.difference(widget.order.checkOutDay).inDays.toString()} days",
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Row(
                children: [
                  (Icon(Icons.people)),
                  Text(widget.order.customerCount.toString()),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

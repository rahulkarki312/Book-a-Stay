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

    return Dismissible(
      key: ValueKey(widget.order.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Are you sure?"),
                content: const Text("Do you want to delete this booking?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Yes"))
                ],
              )),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Orders>(context, listen: false)
            .removeOrder(widget.order.id);
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('${bookedHotel.title}  \$${widget.order.price}'),
              subtitle: Text(
                "${widget.order.checkOutDay.difference(widget.order.checkInDay).inDays} days",
                // "${widget.order.checkOutDay} ${widget.order.checkInDay}"
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
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import '../Provider/order.dart';
import 'package:intl/intl.dart';

//here we use stateful widgets when there are chanegs in the local state of the widget not the app wide change that is it affects only this widget or it's child
class OrderWidget extends StatefulWidget {
  final OrderItem orderdata;
  OrderWidget(this.orderdata);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool isexpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.orderdata.amount.toStringAsFixed(2)}"),
            subtitle: Text(DateFormat("dd/MM/yyyy  hh:mm a")
                .format(widget.orderdata.date)),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    isexpanded = !isexpanded;
                  });
                },
                icon: Icon(isexpanded == true
                    ? Icons.expand_less
                    : Icons.expand_more)),
          ),
          //we use this if method to enable that if the condition is true then show this widget else not
          if (isexpanded == true)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: min(widget.orderdata.products.length * 20 + 10, 100),
                child: ListView(
                  children: widget.orderdata.products
                      .map((e) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Text(
                                "${e.quantity}x",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              Text(
                                "\$${e.price.toStringAsFixed(2)}",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              )
                            ],
                          ))
                      .toList(),
                ),
              ),
            )
        ],
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productid;
  final String title;
  final double price;
  final int quantity;
  CartItem(
      {required this.title,
      required this.id,
      required this.quantity,
      required this.price,
      required this.productid});
  @override
  Widget build(BuildContext context) {
    Key cartkey = ValueKey(id);
    return Dismissible(
      key: cartkey,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deletecartitem(productid);
      },
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        // we have to return a future value which would later be return as we want here it's asking for a bool so we can return a future value of true/false
        // To implement this future value we use the showDialog widget
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Are you sure?"),
              content: Text("The item will be removed from your cart"),
              actions: [
                TextButton(
                    onPressed: () {
                      // now the show dialog would be able to see the value whenwe pass it through Navigator.pop method and passing the abrupt data there it's asking for bool we would pass bool only
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text("NO")),
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text("YES")),
              ],
            );
          },
        );
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.only(right: 10),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                  child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("\$${price}"),
              )),
            ),
            title: Text(title),
            subtitle: Text("Total:\$${(price * quantity)}"),
            trailing: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${quantity}x",
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Provider.of<Cart>(context, listen: false)
                                .alterqtyadd(productid);
                          },
                          child: Icon(Icons.add)),
                      TextButton(
                          onPressed: () {
                            Provider.of<Cart>(context, listen: false)
                                .alterqtyremove(productid);
                          },
                          child: Icon(Icons.remove))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/cart.dart' show Cart;
import '../Provider/order.dart';
import '../Widgets/cart_item.dart';

class Cartscreen extends StatefulWidget {
  static const routename = '/cart';

  @override
  State<Cartscreen> createState() => _CartscreenState();
}

class _CartscreenState extends State<Cartscreen> {
  bool isenable = true;

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    if (cart.cartcount() == 9) {
      isenable = false;
    }
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  // we use spacer such that the elements take the edges and space take all the rest space which is unused used mostly for distinguishing elements ina row/column
                  Spacer(),
                  // we use the chip widget to show an container with rounded corner
                  Chip(
                    label: Text(
                      '\$${cart.carttotalprice().toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Stack(children: [
                    isloading == true
                        ? Padding(
                            padding: const EdgeInsets.only(left: 26.0, top: 4),
                            child: CircularProgressIndicator(
                                // ignore: deprecated_member_use
                                color: Theme.of(context).colorScheme.secondary),
                          )
                        : SizedBox(),
                    TextButton(
                        onPressed: isenable == true
                            ? () async {
                                setState(() {
                                  isloading = true;
                                  isenable = false;
                                });
                                await Provider.of<Orders>(context,
                                        listen: false)
                                    .addorder(cart.carttotalprice(),
                                        cart.items.values.toList())
                                    .catchError((error) {
                                  isenable = true;
                                  isloading = false;
                                  print(error);
                                });
                                setState(() {
                                  isenable = false;
                                  isloading = false;
                                });

                                cart.clearcart();
                              }
                            : null,
                        child: Text("ORDER NOW")),
                  ])
                ],
              ),
            ),
          ),
          Divider(),
          // rather than hardcoding the container height of listview use the expanded widget which ensures that it's child widget would take as much space as left in the column
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                final cartitem = cart.items.values.toList()[index];
                return CartItem(
                  title: cartitem.title,
                  id: cartitem.id,
                  quantity: cartitem.quantity,
                  price: cartitem.price,
                  productid: cart.items.keys.toList()[index],
                );
              },
              itemCount: cart.cartcount(),
            ),
          )
        ],
      ),
    );
  }
}

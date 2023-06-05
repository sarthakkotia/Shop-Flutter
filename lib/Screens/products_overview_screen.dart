// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/prudcts_grid.dart';
import '../Widgets/badgewidget.dart';
import '../Widgets/drawer.dart';
import './cart_screen.dart';
import '../Provider/cart.dart';
import '../Provider/products_provider.dart';

enum Popupbutton { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool showfavs = false;
  bool isloading = false;

  //Now if we want to show the saved products for which we are needed to connect to firebase
  // as it has to be done instantly hence we declare it in our init state
  @override
  void initState() {
    isloading = true;
    // we have declared a function so that we can later use to fetch the products
    Provider.of<Products>(context, listen: false).fetchdata().then((_) {
      setState(() {
        isloading = false;
      });
    }).catchError((error) {
      return showDialog<Null>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("An error occured"),
            content: Text(error.toString()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        },
      );
    });
    // however hte course have also helped us in using different techniques for this
    //for example
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchdata();
    // });
    // or simply use didchange dependencies and use Provider.of<Products>(context).fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final cartcount = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      drawer: Drawerwidget(),
      appBar: AppBar(title: Text("MyShop"), actions: [
        // Popup menu button creates a list on the upper right corner of the screen with button defined bby popup menu item

        PopupMenuButton(
          onSelected: (value) {
            setState(() {
              if (value == Popupbutton.Favorites) {
                showfavs = true;
              } else {
                showfavs = false;
              }
            });
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: Text("Favorites"), value: Popupbutton.Favorites),
              PopupMenuItem(child: Text("Show All"), value: Popupbutton.All)
            ];
          },
        ),
        Consumer<Cart>(
          builder: (context, cartcount, ch) {
            return Badgewidget(
                color: Theme.of(context).colorScheme.secondary,
                child: ch as Widget,
                value: cartcount.cartcount().toString());
          },
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Cartscreen.routename);
              },
              icon: Icon(Icons.shopping_cart)),
        )
      ]),
      body: isloading == true
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary),
            )
          : ProductsGrid(showfavs),
    );
  }
}

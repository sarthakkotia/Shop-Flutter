// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Screens/products_overview_screen.dart';
import './Screens/product_details_screen.dart';
import './Screens/cart_screen.dart';
import './Screens/orders_screen.dart';
import './Screens/manage_products_screen.dart';
import './Screens/add_products.dart';
import './Provider/products_provider.dart';
import './Provider/cart.dart';
import './Provider/order.dart';
import './Screens/auth_screen.dart';
import './Provider/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // here with the help of provider package we use this changenotifer widget for state management

    //Now if we want to use multiple providers so rathe rthan nesting the providers we can use MultiProvider class and in that use the providers argument and in that list put all the Providers we want to have
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (BuildContext context) => Products(
                Provider.of<Auth>(context, listen: false).userid,
                Provider.of<Auth>(context, listen: false).token.toString(), []),
            update: (ctx, auth, previous) => Products(auth.userid, auth.token!,
                previous == null ? [] : previous.items)
            // with the help of the create method of this widget we setup the instance of the class Products
            //here we are using the create methiod because it is recommended for efficiency that if you are instantiaitng a new class use the crete method howver if your are using an old data use the .value constructor of changenotifierprovider
            ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (BuildContext context) => Orders(
              Provider.of<Auth>(context, listen: false).token.toString(),
              [],
              Provider.of<Auth>(context, listen: false).userid),
          update: (ctx, Auth, previous) => Orders(
              Auth.token!, previous == null ? [] : previous.order, Auth.userid),
        ),
      ],
      //we wrap it with the consumer app as to say that whenever the auth object changes the app would rebuild
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          // throught his consumer we can access the nwewest auth object
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              fontFamily: "Lato",
              primarySwatch: Colors.purple,
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange)),
          home: auth.isAuth == true ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetails.routename: (context) => ProductDetails(),
            Cartscreen.routename: (context) => Cartscreen(),
            OrderScreen.routename: (context) => OrderScreen(),
            ManageProductsScreen.routename: (context) => ManageProductsScreen(),
            AddProduct.routename: (context) => AddProduct()
          },
        ),
      ),
    );
  }
}

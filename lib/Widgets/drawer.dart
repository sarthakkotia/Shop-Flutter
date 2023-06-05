import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/orders_screen.dart';
import '../Screens/manage_products_screen.dart';
import '../Provider/auth.dart';

class Drawerwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // rather than using a drawer header which is really long in height and takes up  a lot of space we can use appbar widget here as well
          AppBar(
            title: Text("Hello Friend!"),
            // the below argument means to allw flutter to automaticall add a button like a back button or something like that in this case we don't need we are usign this just like a UI widget
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            title: Text(
              "Shop",
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.shop),
            onTap: () {
              // the home will have default route as '/
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            title: Text(
              "Orders",
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.payment),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routename);
            },
          ),
          ListTile(
            title: Text(
              "Manage Products",
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageProductsScreen.routename);
            },
          ),
          ListTile(
            title: Text(
              "Logout",
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(ManageProductsScreen.routename);
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}

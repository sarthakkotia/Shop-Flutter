// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/products_provider.dart';
import '../Screens/add_products.dart';

class ManageProduct extends StatelessWidget {
  String id;
  String imageurl;
  String title;
  ManageProduct(this.id, this.imageurl, this.title);

  @override
  Widget build(BuildContext context) {
    final scaffoldmessanger = ScaffoldMessenger.of(context);
    return Container(
      padding: EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageurl),
        ),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AddProduct.routename, arguments: id);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  )),
              IconButton(
                  onPressed: () async {
                    await Provider.of<Products>(context, listen: false)
                        .deleteproduct(id)
                        .catchError((error) {
                      // catchError would be the error we have thrown
                      scaffoldmessanger.showSnackBar(SnackBar(
                        content: Text("Couldn't delete"),
                        behavior: SnackBarBehavior.floating,
                      ));
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${title} is removed from the roster!"),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

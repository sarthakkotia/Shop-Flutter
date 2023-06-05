import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/products_provider.dart';

class ProductDetails extends StatelessWidget {
  static const routename = '/product-details';

  @override
  Widget build(BuildContext context) {
    // here we used a questionmark and a dot to access it so that if the setting is null then it may not cause any problem
    final Productid = ModalRoute.of(context)?.settings.arguments as String;
    //here while setting tup thr provider of context we set listen to flase as to tell that don't actively listen for changes and rebuild
    final loadedproduct = Provider.of<Products>(context, listen: false)
        .searchproductbyid(Productid);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedproduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Hero(
              tag: loadedproduct.id,
              child: Image.network(
                loadedproduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "\$${loadedproduct.price}",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${loadedproduct.description}",
              textAlign: TextAlign.center,
            ),
          )
        ]),
      ),
    );
  }
}

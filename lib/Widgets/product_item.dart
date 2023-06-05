import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/product_details_screen.dart';
import '../Provider/product.dart';
import '../Provider/cart.dart';
import '../Provider/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem({required this.id, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    String Token = Provider.of<Auth>(context, listen: false).token.toString();
    String userId = Provider.of<Auth>(context, listen: false).userid;
    // Now the provider of is a method which stores data into a variable for it's correct fucntioning we are needed to rebuild the widget everytime
    // however if we don't want to rebuild then we could use listen = false and only listen at the fisrt build
    // but what if we want some parts of the widget itself to listen everytime and other don't for example here if we want to actively listen for the favorite button and listen once for title,oimageurl then we use the consumer widget
    final proddetails = Provider.of<Product>(context, listen: false);
    // the above code will look for the product provided which is products[i]
    // ignore: unused_local_variable
    final cartdetails = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetails.routename, arguments: proddetails.id);
          },
          //the fadeinimage widget is used for fading in the image after it's loaded before that a placeholder image is used defined in the property
          //we have also used here a hero widget which is a widget used mainly on images what it does is enlarge the tapped image and then floats into it's place into product details screen 
          child: Hero(
            // the tag is used to identify the relation b/w this and the product details screen 
            // and we relate this with the hero widget to product details screen
            tag: proddetails.id,
            child: FadeInImage(
              placeholder: AssetImage("lib/Assets/Images/download.png"),
              image: NetworkImage(proddetails.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // Now we use the consumer widget So that we can tell dart that see look for changes and only rebuild the widgetit's builder function is returning
          // if you parts on the widget which is needn't to be rebuild then define the child in consumer and reference it in the builder fucnction
          leading: Consumer<Product>(
            builder: (context, proddetails, child) => IconButton(
                onPressed: () async {
                  await proddetails
                      .toggleFavorite(Token, userId)
                      .catchError((error) {
                    print(error);
                  });
                },
                icon: Icon(
                  proddetails.isFavorite == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                )),
          ),
          title: Text(proddetails.title, textAlign: TextAlign.center),
          trailing: Consumer<Cart>(
            builder: (context, cartdetails, child) {
              return IconButton(
                  onPressed: () {
                    cartdetails.addItem(
                        proddetails.id, proddetails.title, proddetails.price);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    //Now we want that when we add an item in the cart show a snackbar ie a bottom popup so that the user may know that ite item is added and provides the user option to undo
                    // this snackbar messenger is used for showing snack bar
                    // we use the of context method
                    // the of method always take the context and establishes a connection behind the scenes ie the nearest scaffold widget that will be at the productoverview screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("${proddetails.title} is added to the cart!"),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () {
                              cartdetails.removeSingleItem(proddetails.id);
                            }),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.deepOrange,
                  ));
            },
          ),
        ),
      ),
    );
  }
}

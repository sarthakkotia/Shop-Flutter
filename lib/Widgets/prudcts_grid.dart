import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../Provider/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showfavs;
  ProductsGrid(this.showfavs);

  // in this procucts grid scrrenn we get it that it would need the necessary data for the list of products which can be accessed by provider.of context and with the help of angled brackets we are telling the provider to anly look for the <Products> class
  // then we save this provider result and access it's getter ie items so now whenver the class changes this will listen
  @override
  Widget build(BuildContext context) {
    final products_data = Provider.of<Products>(context);
    // print(showfavs);
    final products =
        showfavs == true ? products_data.favorites : products_data.items;
    // print(products.length);
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (_, index) {
        // here instead of reinstantiating the Product class we can use the product which is already present in the products list defineed in Provider of products
        return ChangeNotifierProvider.value(
          // using the .value constructor of changenotifierprovider as we are using the old value in the method rather than instantitating a new class aslso this it's recommended to use .value in grid/list
          value: products[index],
          //create: (context) => products[index],
          child: ProductItem(),
        );
      },
    );
  }
}

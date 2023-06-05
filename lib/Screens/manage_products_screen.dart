import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/products_provider.dart';
import '../Widgets/drawer.dart';
import '../Widgets/product_mage.dart';
import '../Screens/add_products.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routename = "/manage-products";
  const ManageProductsScreen({super.key});

  Future<void> refreshprod(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Products"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddProduct.routename);
                },
                icon: Icon(Icons.add))
          ],
        ),
        drawer: Drawerwidget(),
        body: RefreshIndicator(
          // ignore: deprecated_member_use
          color: Theme.of(context).colorScheme.secondary,
          onRefresh: () => refreshprod(context),
          child: Container(
            child: ListView.builder(
              itemBuilder: (context, index) => Column(
                children: [
                  ManageProduct(
                      products.items[index].id,
                      products.items[index].imageUrl,
                      products.items[index].title),
                  Divider()
                ],
              ),
              itemCount: products.items.length,
            ),
          ),
        ));
  }
}

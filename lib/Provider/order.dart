import 'dart:convert';
import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final DateTime date;
  final double amount;
  final List<CartItem> products;
  OrderItem(
      {required this.amount,
      required this.date,
      required this.id,
      required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> orders = [];

  List<OrderItem> get order {
    return [...orders];
  }

  final String token;
  final userId;
  Orders(this.token, this.orders, this.userId);

  Future<void> fetchorders() async {
    try {
      final url = Uri.parse(
          "https://flutter-959c6-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$token");
      final response = await http.get(url);
      // print(response.body);
      var test = json.decode(response.body) as Map<String, dynamic>;
      // print(test);
      List<OrderItem> orderdata = [];
      // if the test is empty ie
      // the orders is empty in firebase then a error would occur on the forEach method
      // hence we need to to handle this case by
      // ignore: unnecessary_null_comparison
      if (test == null) {
        return;
      }
      test.forEach((key, value) {
        orderdata.insert(
          0,
          OrderItem(
            amount: value['amount'],
            date: DateTime.parse(value['date']),
            id: key,
            products: (value['products'] as List<dynamic>)
                .map((e) => CartItem(
                    id: e['id'],
                    price: e["price"],
                    quantity: e["quantity"],
                    title: e['title']))
                .toList(),
          ),
        );
      });
      orders = orderdata;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addorder(double total, List<CartItem> productlist) async {
    // here we used the insert function so that more recent orders will be at beginning ie every new order will be added in front of the list
    final url = Uri.parse(
        "https://flutter-959c6-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$token");
    // final response = await http.post(url,
    //     body: json.encode({
    //       'date': DateTime.now().toString(),
    //       'amount': total,
    //       'products': productlist.toString()
    //     }));
    // List<Map<String, dynamic>> testmap = [];
    // productlist.forEach(
    //   (element) {
    //     testmap.add({
    //       'title': element.title,
    //       'price': element.price,
    //       'quantity': element.quantity,
    //     });
    //   },
    // );
    // print(testmap);
    try {
      // we are declaring this variable here so that we can have a consisten dattime in both http post request as well as local data
      final datetime = DateTime.now();
      final response = await http
          .post(url,
              body: json.encode({
                //When passing datetime use DateTime.now().toIso8601String this is an uniform string represention of dates which we can later easily convert back to a datetime object
                // always send this special representaion which is easily recreatable as datetime later
                'date': datetime.toIso8601String(),
                'amount': total,
                'products': productlist
                    .map((e) => {
                          'id': e.id,
                          'title': e.title,
                          'price': e.price,
                          'quantity': e.quantity,
                        })
                    .toList()
              }))
          .catchError((error) {
        throw error;
      });
      orders.insert(
          0,
          OrderItem(
              amount: total,
              date: datetime,
              id: json.decode(response.body)['name'],
              products: productlist));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

import 'package:flutter/material.dart';

class CartItem {
  // here the id is the cart item id not the prodcut id
  final String id;
  final String title;
  int quantity;
  final double price;
  CartItem(
      {required this.id,
      required this.price,
      required this.quantity,
      required this.title});
}

class Cart with ChangeNotifier {
  // here we use the key as the product id and it's value as the cartitem corresponding to that product
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productid, String title, double price) {
    // check if the item is laready in the items list if not than add the item else increase its quatntiy
    if (_items.containsKey(productid) == true) {
      // change quatity
      _items.update(
          productid,
          (cartitem) => CartItem(
              id: cartitem.id,
              price: cartitem.price,
              quantity: cartitem.quantity + 1,
              title: cartitem.title));
    } else {
      _items.addAll({
        productid: CartItem(
            price: price,
            title: title,
            quantity: 1,
            id: DateTime.now().toString())
      });
    }
    // print(_items.length);
    // _items.forEach(
    //   (key, value) {
    //     print(key);
    //     print(value.id);
    //     print(value.title);
    //     print(value.price);
    //     print(value.quantity);
    //   },
    // );
    notifyListeners();
  }

  int cartcount() {
    // print(_items);
    return _items.length;
  }

  double carttotalprice() {
    double sum = 0;
    _items.forEach((key, value) {
      sum = sum + value.price * value.quantity;
    });
    return sum;
  }

  void deletecartitem(String productid) {
    _items.remove(productid);
    // _items.removeWhere((key, value) => Key(value.id) == keyid);
    notifyListeners();
  }

  void alterqtyadd(String productid) {
    //print(productid);
    _items.update(productid, (value) {
      value.quantity++;
      return value;
    });
    notifyListeners();
  }

  void alterqtyremove(String productid) {
    bool remove = false;
    _items.update(productid, (value) {
      value.quantity--;
      if (value.quantity == 0) {
        remove = true;
      }
      return value;
    });
    if (remove == true) {
      deletecartitem(productid);
    }
    notifyListeners();
  }

  void clearcart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productid) {
    if (!_items.containsKey(productid)) {
      return;
    }
    if (_items[productid]?.quantity == 1) {
      _items.remove(productid);
    } else {
      _items.update(
          productid,
          (value) => CartItem(
              id: value.id,
              price: value.price,
              quantity: value.quantity - 1,
              title: value.title));
    }
    notifyListeners();
  }
}

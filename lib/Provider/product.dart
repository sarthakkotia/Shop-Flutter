import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  // here we have not defined isfavorite as final as we want this argument to be changed later
  bool isFavorite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final url = Uri.parse(
        "https://flutter-959c6-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token");
    try {
      // we don't want to append the data everytime ratehr we want to aoverwrite the data
      // hence we would send a put request
      await http.put(url, body: json.encode(!isFavorite)).then((_) {
        // print("then should work");
        isFavorite = !isFavorite;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
    // isFavorite = !isFavorite;
    // notifyListeners();
  }
}

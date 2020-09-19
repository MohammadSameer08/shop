import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorites(String token,String userId) {
    var fav = isFavorite;
    final url = "https://shop-49945.firebaseio.com/userFavorite/$userId.json?auth=$token";
    isFavorite = !isFavorite;
    notifyListeners();
    return http
        .patch(url,
            body: json.encode({
             id:isFavorite,
            }))
        .catchError((error) {
      isFavorite = fav;
    }).then((response) {
    });
  }
}

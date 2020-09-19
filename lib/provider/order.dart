import "package:flutter/material.dart";
import 'package:shop/provider/Cart.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final int price;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.price, this.products, this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _order = [];

  List<OrderItem> get order {
    return [..._order];
  }
  final String userId;
  Order(this.userId,this._order);
  Future<void> fetchAndSetOrders(String token) {
    final url = "https://shop-49945.firebaseio.com/orders/$userId.json?auth=$token";
    return http.get(url).then((response) {
      var extractData = json.decode(response.body) as Map<String, dynamic>;

        if(extractData==null)
          {
            return;
          }

      List<OrderItem> loadedProducts = [];

      extractData.forEach((key, value) {
        loadedProducts.add(OrderItem(
          id: key,
          price: value["price"],
          dateTime: DateTime.parse(value["dateTime"]),
          products: (value["products"] as List<dynamic>)
              .map(
                (items) => CartItem(
                    id: items["id"],
                    price: items["price"],
                    quantity: items["quantity"],
                    title: items["title"]),
              )
              .toList(),
        ));
      });
      _order=loadedProducts;
      notifyListeners();

    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, int totalAmount,String token) {
    final currentTime = DateTime.now();
    final url = "https://shop-49945.firebaseio.com/orders/$userId.json?auth=$token";
    return http
        .post(url,
            body: json.encode({
              "price": totalAmount,
              "dateTime": currentTime.toIso8601String(),
              "products": cartProducts
                  .map((cartProd) => {
                        "id": cartProd.id,
                        "title": cartProd.title,
                        "price": cartProd.price,
                        "quantity": cartProd.quantity
                      })
                  .toList(),
            }))
        .then((response) {
      _order.insert(
          0,
          OrderItem(
              id: json.decode(response.body)["name"],
              price: totalAmount,
              products: cartProducts,
              dateTime: currentTime));

      notifyListeners();
    });
  }
}

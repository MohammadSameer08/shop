import "package:flutter/material.dart";

class CartItem {
  final String id; //not same as product id
  final String title;
  final int price;
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  int get length {
    return _cartItems.length;
  }

  int get total {
    int sum = 0;
    _cartItems.forEach((key, item) {
      sum += item.price * item.quantity;
    });
    return sum;
  }

  void addChatItems(String productId, int price, String title) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cartItems.containsKey(productId)) return;
    if (_cartItems[productId].quantity > 1) {
      _cartItems.update(
          productId,
          (existingProductItem) => CartItem(
              id: existingProductItem.id,
              title: existingProductItem.title,
              price: existingProductItem.price,
              quantity: existingProductItem.quantity - 1));
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void deleteCartItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clear() {
    _cartItems = {}; // when we order we need to clear cart items...
    notifyListeners();
  }
}

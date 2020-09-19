import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Auth.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/order.dart';
import 'package:shop/widget/cart-item.dart';

class CartItemScreen extends StatelessWidget {
  static const routName = "/CartItem";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Yours Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "Rs:" + cart.total.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.purple,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (ctx, i) => CartItemWidget(
                    cart.cartItems.values.toList()[i].id,
                    cart.cartItems.values.toList()[i].price,
                    cart.cartItems.values.toList()[i].quantity,
                    cart.cartItems.values.toList()[i].title,
                    cart.cartItems.keys.toList()[
                        i] // since we are placing data in map with product id as a key
                    )),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text("ORDER NOW"),
      textColor: Colors.purple,
      onPressed: (widget.cart.total <= 0 || isLoading)
          ? null
          : () {
              setState(() {
                isLoading = true;
              });
              final token = Provider.of<Auth>(context).token;
              final userId = Provider.of<Auth>(context).userId;

              Provider.of<Order>(context)
                  .addOrder(widget.cart.cartItems.values.toList(),
                      widget.cart.total, token)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
              });
              widget.cart.clear();
            },
    );
  }
}

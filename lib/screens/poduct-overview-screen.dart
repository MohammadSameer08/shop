import 'package:flutter/material.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/cart-screen.dart';
import 'package:shop/widget/baged.dart';
import 'package:shop/widget/mydrawer.dart';
import 'package:shop/widget/products-grid.dart';
import 'package:provider/provider.dart';

class ProductOverViewScreen extends StatefulWidget {
  static const routName = "/productOverView";

  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showFavoritesOnly = false;
  var _isLoading = false;
  var _isInt = true;

  @override
  void didChangeDependencies() {
    if (_isInt) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts(false).catchError((error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An error occurred!"),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      super.didChangeDependencies();
    }
    _isInt = false;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("MyShop"),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (int value) {
                setState(() {
                  if (value == 0) {
                    _showFavoritesOnly = true;
                  } else {
                    _showFavoritesOnly = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  child: Text("Only Favorites"),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text("Show All"),
                  value: 1,
                )
              ],
            ),
            Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartItemScreen.routName);
                },
              ),
              value: cart.length.toString(),
              color: Colors.red,
            ),
          ],
        ),
        drawer: MyDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showFavoritesOnly));
  }
}

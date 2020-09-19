import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/provider/Auth.dart';
import 'package:shop/provider/product.dart';
import 'package:shop/screens/product-detail-screen.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context).token;
    final userId = Provider.of<Auth>(context).userId;
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routName,
                  arguments: product.id);
            },
            child: Hero(
              tag:product.id,
              child: FadeInImage(
                placeholder: AssetImage("images/product-placeholder.png"),
                image: NetworkImage(
                  product.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.toggleFavorites(token, userId);
            },
            color: Colors.deepOrange,
          ),
          title: FittedBox(
            child: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addChatItems(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();

              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Added item to Cart!"),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}

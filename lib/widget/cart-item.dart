import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final int price;
  final int quantity;
  final String title;
  final String productId;

  CartItemWidget(
      this.id, this.price, this.quantity, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        final item = Provider.of<Cart>(context);
        item.deleteCartItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are You Sure"),
                  content: Text("Do you really want to remove this item?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                      child: Text(
                    "Rs:" + price.toString(),
                    style: TextStyle(color: Colors.white),
                  ))),
            ),
            title: Text(title),
            subtitle: Text("Rs:" + (price * quantity).toString()),
            trailing: Text(quantity.toString() + "x"),
          ),
        ),
      ),
    );
  }
}

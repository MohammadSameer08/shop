import 'package:flutter/material.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/edit-product-screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.purple,
              ),
              onPressed: () {

                Navigator.of(context)
                    .pushNamed(UserEditScreen.routName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<Products>(context).deleteProduct(id);
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/edit-product-screen.dart';
import 'package:shop/widget/mydrawer.dart';
import 'package:shop/widget/user-product-item.dart';

class UserProductsScreen extends StatefulWidget {
  static const routName = "/user-screen-product";

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var isInt = true;

  @override
  void didChangeDependencies() {
    if (isInt) {
      Provider.of<Products>(context).fetchAndSetProducts(true);
    }
    isInt = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(UserEditScreen.routName);
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<Products>(context).fetchAndSetProducts(true),
        child: Provider.of<Products>(context).items.length <=0
            ? Center(
                child: Text(
                  "No Product Added yet!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: productData.items.length,
                  itemBuilder: (ctx, i) => Column(
                    children: <Widget>[
                      UserProductItem(
                        productData.items[i].id,
                        productData.items[i].title,
                        productData.items[i].imageUrl,
                      ),
                      Divider()
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

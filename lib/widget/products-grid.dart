import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/widget/productitem.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {

  final bool favoritesOnly;
  ProductsGrid(this.favoritesOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts =favoritesOnly?productsData.favoritesProducts:productsData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value:loadedProducts[i],
        child:ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

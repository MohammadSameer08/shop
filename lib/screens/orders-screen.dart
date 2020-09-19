import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Auth.dart';
import 'package:shop/provider/order.dart';
import 'package:shop/widget/mydrawer.dart';
import 'package:shop/widget/order-Items-widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routName = "/orderScreen";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isInt = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInt) {
      setState(() {
        isLoading = true;
      });
      final auth = Provider.of<Auth>(context);
      //final userId = Provider.of<Auth>(context).userId;

      Provider.of<Order>(context).fetchAndSetOrders(auth.token)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Empty!"),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      })
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    _isInt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: MyDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (orderData.order.length == 0)
              ? Center(
                  child: Text(
                    "No Orders Yet! :)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: orderData.order.length,
                  itemBuilder: (ctx, i) => OrderItemWidget(orderData.order[i]),
                  //orderData.order[i].price .....
                ),
    );
  }
}

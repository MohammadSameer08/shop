import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/helper/custom_routs.dart';
import 'package:shop/provider/Auth.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/order.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart-screen.dart';
import 'package:shop/screens/edit-product-screen.dart';
import 'package:shop/screens/orders-screen.dart';
import 'package:shop/screens/poduct-overview-screen.dart';
import 'package:shop/screens/product-detail-screen.dart';
import 'package:shop/screens/splash-screen.dart';
import 'package:shop/screens/user-product-screen.dart';
import './provider/products.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        // this will not build the ui again because they are providers
        //Listeners will build the ui again
        // ex: Provider.of<...>Context();
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            update: (ctx, auth, previousOrders) => Order(auth.userId,
                previousOrders == null ? [] : previousOrders.order),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              fontFamily: "Lato",
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionsBuilder(),
                TargetPlatform.iOS: CustomPageTransitionsBuilder(),
              }),
            ),
            home: auth.isAuth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ProductOverViewScreen.routName: (ctx) => ProductOverViewScreen(),
              ProductDetailScreen.routName: (ctx) => ProductDetailScreen(),
              CartItemScreen.routName: (ctx) => CartItemScreen(),
              OrdersScreen.routName: (ctx) => OrdersScreen(),
              UserProductsScreen.routName: (ctx) => UserProductsScreen(),
              UserEditScreen.routName: (ctx) => UserEditScreen()
            },
          ),
        ));
  }
}

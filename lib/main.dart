import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/screens/product_overview_screen.dart';
import 'package:flutter_ecommerce/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';

import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/auth_screen.dart';

void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (context) => Order(),
          update: (ctx, authvalue, previousOrder) => previousOrder
            ..getData(authvalue.token, authvalue.userId,
                previousOrder == null ? [] : previousOrder.orders),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (ctx, authvalue, previousProducts) => previousProducts
            ..getData(authvalue.token, authvalue.userId,
                previousProducts == null ? [] : previousProducts.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: ((ctx, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? ProductOverViewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, AsyncSnapshot authsnapshot) =>
                          authsnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
                CartScreen.routeName: (_) => CartScreen(),
                OrderScreen.routeName: (_) => OrderScreen(),
                UserProductScreen.routeName: (_) => UserProductScreen(),
                EditProductScreen.routeName: (_) => EditProductScreen(),
              },
            )),
      ),
    );
  }
}

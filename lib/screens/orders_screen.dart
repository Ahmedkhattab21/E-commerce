import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/app_drawer.dart';
import '../Widgets/order_item.dart';
import '../providers/orders.dart' show Order;

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Order")),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.error != null) {
              return Text('An error Occured!');
            } else {
              return Consumer<Order>(
                builder: ((context, value, child) => ListView.builder(
                      itemCount: value.orders.length,
                      itemBuilder: (context, index) =>
                          OrderItem(value.orders[index]),
                    )),
              );
            }
          }
        },
      ),
    );
  }
}

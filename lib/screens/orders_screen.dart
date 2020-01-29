import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../provider/orders.dart' show Orders;
import '../widgets/main_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // drawer: MainDrawer(),
      appBar: AppBar(title: Text('Your Orders'), elevation: 0, centerTitle: true),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).getAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                if (orderData.orders.length == 0) {
                  return Center(
                      child: Text(
                    'You didn\'t order anything yet',
                    style: TextStyle(fontSize: 25),
                  ));
                } else {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  );
                }
              });
            }
          }
        },
      ),
    );
  }
}

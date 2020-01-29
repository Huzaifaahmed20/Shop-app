import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './cart.dart' show CartItem;

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double totalAmount;
  final DateTime createdAt;

  OrderItem({
    @required this.id,
    @required this.products,
    @required this.totalAmount,
    @required this.createdAt,
  });
}

class Orders extends ChangeNotifier {
  List<OrderItem> orders = [];
  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this.orders);

  List<OrderItem> get getOrders {
    return [...orders];
  }

  Future<void> getAndSetOrders() async {
    final url = 'https://flutter-firebase-729c6.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];

    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        totalAmount: orderData['totalAmount'],
        createdAt: DateTime.parse(orderData['createdAt']),
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title']))
            .toList(),
      ));
    });
    orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    final url = 'https://flutter-firebase-729c6.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'totalAmount': totalAmount,
          'createdAt': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) =>
                  {'id': cp.id, 'title': cp.title, 'quantity': cp.quantity, 'price': cp.price})
              .toList()
        }));

    orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          createdAt: timeStamp,
          products: cartProducts,
          totalAmount: totalAmount),
    );
    notifyListeners();
  }
}

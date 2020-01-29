import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpanded ? min(widget.orderItem.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        color: Colors.purple,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Rs.${widget.orderItem.totalAmount}',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.createdAt),
                  style: TextStyle(color: Colors.white)),
              trailing: IconButton(
                icon: AnimatedIcon(
                  color: Colors.white,
                  icon: AnimatedIcons.view_list,
                  progress: _controller,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                  _isExpanded ? _controller.forward() : _controller.reverse();
                },
              ),
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: _isExpanded ? min(widget.orderItem.products.length * 20.0 + 10, 100) : 0,
                child: ListView(
                    children: widget.orderItem.products
                        .map((product) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${product.title}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                Text(
                                  'x${product.quantity}   Rs.${product.price}',
                                  style: TextStyle(fontSize: 15, color: Colors.white),
                                )
                              ],
                            ))
                        .toList()))
          ],
        ),
      ),
    );
  }
}

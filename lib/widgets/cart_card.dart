import 'dart:convert';

import 'package:bukuku/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CartCard extends StatefulWidget {
  final int id;
  final String title;
  final String author;
  final String imageURL;
  final int amount;
  final double price;
  final Function() refreshCart;

  const CartCard({
    super.key,
    required this.id,
    required this.title,
    required this.author,
    required this.imageURL,
    required this.amount,
    required this.price,
    required this.refreshCart,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  late int _amount;
  late CartPage cartPage;
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amount = widget.amount;
  }

  void _increment() {
    setState(() {
      _amount++;
    });
    widget.refreshCart();
  }

  void _decrement() {
    if (_amount > 1) {
      setState(() {
        _amount--;
      });
      widget.refreshCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.imageURL,
              height: 120.0,
              width: 90.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Author: ${widget.author}'),
                  Text(
                    'Rp. ${(15000 * (widget.price * _amount)).toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await request.postJson(
                              "http://127.0.0.1:8000/cart/delete-cart-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.id,
                              }));

                          widget.refreshCart();
                        },
                      ),
                      const Spacer(), // Flexible space

                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () async {
                          await request.postJson(
                              "http://127.0.0.1:8000/cart/decrease-cart-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.id,
                              }));

                          _decrement();
                        },
                      ),
                      Expanded(
                          child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: _amount.toString(),
                          hintStyle: const TextStyle(color: Colors.green),
                        ),
                        onChanged: (value) async {
                          final newAmount = int.tryParse(value) ?? _amount;
                          await request.postJson(
                              "http://127.0.0.1:8000/cart/edit-cart-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.id,
                                'amount': newAmount,
                              }));
                          setState(() {
                            _amount = newAmount;
                          });
                          await widget.refreshCart();
                        },
                        onEditingComplete: () {
                          _amountController.clear();
                        },
                        maxLines: 1, // Set maxLines to 1
                        textAlign: TextAlign.center, // Align text to center
                      )),

                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () async {
                          await request.postJson(
                              "http://127.0.0.1:8000/cart/increase-cart-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.id,
                              }));

                          _increment();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

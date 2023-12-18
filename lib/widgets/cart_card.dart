// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bukuku/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  final TextEditingController _amountController = TextEditingController();

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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust as needed
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 254, 255, 254), // Set your desired background color
          borderRadius: BorderRadius.circular(8.0), // Adjust as needed
          boxShadow: [
            BoxShadow(
              color:
                  Colors.grey.withOpacity(0.5), // Set shadow color and opacity
              spreadRadius: 2, // Set spread radius
              blurRadius: 5, // Set blur radius
              offset:
                  const Offset(0, 3), // Set offset to control shadow direction
            ),
          ],
        ),
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
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.green),
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
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          final response = await request.postJson(
                              "https://bukuku-d01-tk.pbp.cs.ui.ac.id/cart/delete-cart-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.id,
                              }));
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Item successfully deleted.",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(milliseconds: 400),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Action failed, please try again.",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(milliseconds: 400),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ));
                          }

                          widget.refreshCart();
                        },
                      ),
                      const Spacer(), // Flexible space

                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          final response = await request.postJson(
                              "https://bukuku-d01-tk.pbp.cs.ui.ac.id/cart/decrease-cart-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.id,
                              }));
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Item amount successfully decrease.",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(milliseconds: 400),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Action failed, please try again.",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(milliseconds: 400),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ));
                          }
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
                        onSubmitted: (value) async {
                          int newAmount = int.tryParse(value) ?? _amount;
                          if (newAmount <= 0) {
                            newAmount = _amount;
                          }
                          final response = await request.postJson(
                              "https://bukuku-d01-tk.pbp.cs.ui.ac.id/cart/edit-cart-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.id,
                                'amount': newAmount,
                              }));
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Item amount successfully changed.",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(milliseconds: 400),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Action failed, please try again.",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(milliseconds: 400),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ));
                          }
                          setState(() {
                            _amount = newAmount;
                          });
                          widget.refreshCart();
                          _amountController.clear();
                        },
                        // onEditingComplete: () {
                        //   _amountController.clear();
                        // },
                        maxLines: 1, // Set maxLines to 1
                        textAlign: TextAlign.center, // Align text to center
                      )),

                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          final response = await request.postJson(
                              "https://bukuku-d01-tk.pbp.cs.ui.ac.id/cart/increase-cart-flutter/",
                              jsonEncode(<String, int>{
                                'id': widget.id,
                              }));
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Item amount successfully increase.",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(milliseconds: 400),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Action failed, please try again.",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(milliseconds: 400),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ));
                          }
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

// ignore_for_file: use_build_context_synchronously
import 'package:bukuku/screens/cart.dart';
import 'package:flutter/material.dart';

class CheckoutCard extends StatefulWidget {
  final int id;
  final String title;
  final String author;
  final String imageURL;
  final int amount;
  final double price;

  const CheckoutCard({
    super.key,
    required this.id,
    required this.title,
    required this.author,
    required this.imageURL,
    required this.amount,
    required this.price,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutCardState createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  late int _amount;

  @override
  void initState() {
    super.initState();
    _amount = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

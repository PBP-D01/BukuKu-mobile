import 'package:bukuku/screens/cart.dart';
import 'package:flutter/material.dart';

class CartCard extends StatefulWidget {
  final String title;
  final String author;
  final String imageURL;
  final int amount;
  final double price;
  final Function() onRemove;
  final Function() onIncrease;
  final Function() onDecrease;

  CartCard({
    required this.title,
    required this.author,
    required this.imageURL,
    required this.amount,
    required this.price,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  late int _amount;
  late CartPage cartPage;

  @override
  void initState() {
    super.initState();
    _amount = widget.amount;
  }

  void _increment() {
    setState(() {
      _amount++;
    });
    widget.onIncrease();
  }

  void _derement() {
    if (_amount > 1) {
      setState(() {
        _amount--;
      });
      widget.onDecrease();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
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
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Author: ${widget.author}'),
                  Text(
                    'Rp. ${(widget.price * _amount).toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: widget.onRemove,
                      ),
                      Spacer(), // Flexible space
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: _increment,
                      ),
                      Text(
                        _amount.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: _derement,
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

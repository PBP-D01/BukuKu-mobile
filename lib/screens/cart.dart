import 'package:bukuku/widgets/cart_card.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Add necessary state variables and functions here
  late int _totalAmount;
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _totalAmount = 4;
    _totalPrice = 100.0;
  }

  void incrementTotal() {
    setState(() {
      _totalAmount++;
      // _totalPrice = _totalPrice * _totalAmount;
    });
  }

  void decrementTotal() {
    setState(() {
      _totalAmount--;
      // _totalPrice = _totalPrice * _totalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BukuKu',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 110, 176, 93),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Replace the following with your actual search bar widget
            const TextField(
              decoration: InputDecoration(
                hintText: 'Cari buku Anda...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30.0),
            // Replace the following with your actual cart details widget
            CartCard(
              title: 'Book Title',
              author: 'Author Name',
              imageURL:
                  'https://m.media-amazon.com/images/I/713KZTsaYpL._AC_UY218_.jpg',
              amount: 2,
              price: 25.0,
              onRemove: () {
                // Implement the logic to remove the item from the cart
              },
              onDecrease: decrementTotal,
              onIncrease: incrementTotal,
            ),
            CartCard(
              title: 'Book Title',
              author: 'Author Name',
              imageURL:
                  'https://m.media-amazon.com/images/I/713KZTsaYpL._AC_UY218_.jpg',
              amount: 2,
              price: 25.0,
              onRemove: () {
                // Implement the logic to remove the item from the cart
              },
              onDecrease: decrementTotal,
              onIncrease: incrementTotal,
            ),

            Card(
              elevation: 3.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _totalAmount.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _totalPrice.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            ),
            // Add the rest of your UI widgets here
          ],
        ),
      ),
    );
  }
}

import 'package:bukuku/screens/cart.dart';
import 'package:bukuku/screens/checkout.dart';
import 'package:bukuku/screens/leaderboard.dart';
import 'package:bukuku/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:bukuku/screens/menu.dart';
import 'package:bukuku/screens/product_page.dart';

class LeftDrawer extends StatelessWidget {
  final int id;
  const LeftDrawer({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            // TODO: Bagian drawer header
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 110, 176, 93),
            ),
            child: Column(
              children: [
                Text(
                  'BukuKu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Beli buku di BukuKu!",
                  style: TextStyle(
                    fontSize: 15, // Ukuran font 15
                    color: Colors.white, // Warna teks putih
                    fontWeight: FontWeight.normal, // Weight biasa
                  ),
                  textAlign: TextAlign.center, // Center alignment
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Leaderboard'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeaderboardPage(id: id)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_library_outlined),
            title: const Text('Cari Produk'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookPage(id: id),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(id: id),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart_checkout),
            title: const Text('Checkout'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutFormPage(
                      id: id,
                      // cartItems: [],
                    ),
                  ));
            },
          ),
           ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(id: id),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

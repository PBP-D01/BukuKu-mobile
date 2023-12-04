import 'package:flutter/material.dart';
import 'package:bukuku/screens/menu.dart';
import 'package:bukuku/screens/checkout_form.dart';


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
                    "Catat seluruh keperluan belanjamu di sini!",
                    style: TextStyle(
                      fontSize: 15,      // Ukuran font 15
                      color: Colors.white,  // Warna teks putih
                      fontWeight: FontWeight.normal,  // Weight biasa
                    ),
                    textAlign: TextAlign.center, // Center alignment
                  )
                  ],
                ),
              ),
          
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(id:id),
                  ));
            },
          ),
        ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Checkout'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutFormPage(id:id),
                  ));
            },
          ),
        ],
      ),
    );
  }
}


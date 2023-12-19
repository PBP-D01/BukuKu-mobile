import 'package:bukuku/models/cart_model.dart';
import 'package:bukuku/screens/checkout.dart';
import 'package:bukuku/screens/product_page.dart';
import 'package:bukuku/widgets/cart_card.dart';
import 'package:bukuku/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartPage extends StatefulWidget {
  final int id;

  const CartPage({super.key, required this.id});
  @override
  // ignore: library_private_types_in_public_api
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Add necessary state variables and functions here
  late int _totalAmount;
  late double _totalPrice;

  Future<List<Cart>> fetchItem() async {
    final int id = widget.id;

    var url = Uri.parse('https://bukuku-d01-tk.pbp.cs.ui.ac.id/cart/get-cart-flutter/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    _totalAmount = 0;
    _totalPrice = 0.0;

    List<Cart> listCart = [];
    for (var d in data) {
      if (d != null && d['user'] == id) {
        Cart cart = Cart.fromJson(d);
        listCart.add(cart);

        _totalAmount += cart.bookAmount;
        _totalPrice += cart.bookPrice * cart.bookAmount;
      }
    }

    return listCart;
  }

  @override
  void initState() {
    super.initState();
    _totalAmount = 0;
    _totalPrice = 0.0;
  }

  void refreshCart() {
    setState(() {
      fetchItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 110, 176, 93),
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(id: widget.id),
      body: FutureBuilder(
          future: fetchItem(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return const Column(
                  children: [
                    Text(
                      "Tidak ada data cart.",
                      style: TextStyle(
                          color: Color.fromARGB(255, 110, 176, 93),
                          fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                if (snapshot.data.isEmpty) {
                  return Center(
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart,
                                    color: Color.fromARGB(255, 110, 176, 93),
                                    size: 100,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Keranjang Kamu Kosong!',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 110, 176, 93))),
                                      Text(
                                          'Mulai belanja sekarang dan dapatkan',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 24, 66, 26))),
                                      Text(
                                          'buku yang kamu inginkan hanya di BukuKu',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 24, 66, 26))),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color.fromARGB(
                                                    255, 110, 176, 93))),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BookPage(id: widget.id)),
                                      );
                                    },
                                    child: const Text(
                                      'Mulai Belanja',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )));
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // const SizedBox(height: 10.0),
                          Card(
                            elevation: 3.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 254, 255,
                                    254), // Set your desired background color
                                borderRadius: BorderRadius.circular(
                                    8.0), // Adjust as needed
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(
                                        0.5), // Set shadow color and opacity
                                    spreadRadius: 2, // Set spread radius
                                    blurRadius: 5, // Set blur radius
                                    offset: const Offset(0,
                                        3), // Set offset to control shadow direction
                                  ),
                                ],
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        "Details",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                            fontSize: 25),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    Row(
                                      children: [
                                        const Text(
                                          "Quantity",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          _totalAmount.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        const Text(
                                          "Total",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Rp. ${(15000 * (_totalPrice)).toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color.fromARGB(
                                                        255, 110, 176, 93))),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckoutFormPage(
                                                        id: widget.id)),
                                          );
                                        },
                                        child: const Text(
                                          'Place Order',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          const SizedBox(height: 50.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.shopping_cart,
                                color: Color.fromARGB(255, 110, 176, 93),
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${snapshot.data.length} Item Added',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 110, 176, 93))),
                                  ]),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var cartItem = snapshot.data![index];
                              return CartCard(
                                id: cartItem.id,
                                title: cartItem.bookTitle,
                                author: cartItem.bookAuthor,
                                imageURL: cartItem.bookImg,
                                amount: cartItem.bookAmount,
                                price: cartItem.bookPrice,
                                refreshCart: refreshCart,
                              );
                            },
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    const Color.fromARGB(255, 110, 176, 93))),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BookPage(id: widget.id)),
                              );
                            },
                            child: const Text(
                              'Tambahkan Item',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            }
          }),
    );
  }
}

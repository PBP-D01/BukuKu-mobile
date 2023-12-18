import 'dart:convert';
import 'package:bukuku/models/cart_model.dart';
import 'package:bukuku/screens/cart.dart';
import 'package:bukuku/widgets/cart_card.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bukuku/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;

class CheckoutFormPage extends StatefulWidget {
  final int id;

  const CheckoutFormPage({Key? key, required this.id}) : super(key: key);

  @override
  State<CheckoutFormPage> createState() => _CheckoutFormPageState();
}

class _CheckoutFormPageState extends State<CheckoutFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstname = "";
  String _lastname = "";
  String _email = "";
  String _address = "";
  List<Cart> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void refreshCart() {
    setState(() {
      fetchCartItems();
    });
  }

  Future<void> fetchCartItems() async {
    final int id = widget.id;
    final request = context.read<CookieRequest>();

    var url = Uri.parse(
        'https://bukuku-d01-tk.pbp.cs.ui.ac.id/cart/get-cart-flutter/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    cartItems = [];
    for (var d in data) {
      if (d != null && d['user'] == id) {
        Cart cart = Cart.fromJson(d);
        cartItems.add(cart);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final int id = widget.id;
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Checkout',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 110, 176, 93),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(id: id),
              ),
            );
          },
        ),
      ),
      drawer: LeftDrawer(id: id),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Section: Cart Items
            Container(
              width:
                  MediaQuery.of(context).size.width * 0.5, // Adjust as needed
              child: cartItems.isEmpty
                  ? Center(
                      child: Text(
                        'Your cart is empty.',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        var cartItem = cartItems[index];
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
            ),
            // Right Section: Checkout Form
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Checkout Form',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "First Name",
                                  labelText: "First Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _firstname = value!;
                                  });
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "First Name cannot be empty!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Last Name",
                                  labelText: "Last Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _lastname = value!;
                                  });
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Last Name cannot be empty!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _email = value!;
                                  });
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email cannot be empty!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Shipping Address",
                                  labelText: "Shipping Address",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _address = value!;
                                  });
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Address cannot be empty!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 110, 176, 93),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final response = await request.postJson(
                              "https://bukuku-d01-tk.pbp.cs.ui.ac.id/checkout/checkout_flutter/",
                              jsonEncode(<String, String>{
                                'first_name': _firstname,
                                'last_name': _lastname,
                                'email': _email,
                                'address': _address,
                              }),
                            );

                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Checkout berhasil!",
                                  ),
                                ),
                              );

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Checkout berhasil!',
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Terima kasih sudah melakukan pembelian, $_firstname.'),
                                          Text(
                                              'Detail pembayaran dapat dilihat pada ($_email)'),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              _formKey.currentState!.reset();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Terdapat kesalahan, silakan coba lagi.",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Continue to Checkout",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

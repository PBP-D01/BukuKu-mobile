import 'dart:convert';
import 'package:bukuku/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bukuku/screens/menu.dart';
import 'package:bukuku/widgets/left_drawer.dart';

class CheckoutFormPage extends StatefulWidget {
  final int id;
  final List<Cart> cartItems;
  const CheckoutFormPage({Key? key, required this.id, required this.cartItems}) : super(key: key);

  @override
  State<CheckoutFormPage> createState() => _CheckoutFormPageState();
}

class _CheckoutFormPageState extends State<CheckoutFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstname = "";
  String _lastname = "";
  String _email = "";
  String _address = "";

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
      ),
      drawer: LeftDrawer(id: id),
      body: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Container(),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Checkout Form',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
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
                                  return "First Name tidak boleh kosong!";
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
                                  return "Last Name tidak boleh kosong!";
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
                                  return "Email tidak boleh kosong!";
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
                                  return "Address tidak boleh kosong!";
                                }
                                return null;
                              },
                            ),
                          ),
                          // Display the cart items
                        ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    var cartItem = widget.cartItems[index];
                    return ListTile(
                      title: Text(cartItem.bookTitle),
                      subtitle: Text('Quantity: ${cartItem.bookAmount}'),
                      // Add more details as needed
                    );
                  },
                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
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
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Terdapat kesalahan, silakan coba lagi.",
                                          ),
                                        ),
                                      );
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Checkout berhasil!',
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Terima kasih sudah melakukan pembelian, $_firstname.'),
                                                Text('Detail pembayaran dapat dilihat pada ($_email)'),
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
                                  }
                                },
                                child: const Text(
                                  "Checkout",
                                  style: TextStyle(color: Colors.white),
                                ),
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
          ],
        ),
      ),
    );
  }
}

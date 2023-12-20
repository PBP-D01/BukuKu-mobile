// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bukuku/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 16.0, left: 16.0, right: 16.0, top: 150),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book,
                      color: Color.fromARGB(255, 110, 176, 93),
                      size: 60,
                    ),
                    SizedBox(width: 10),
                    Text('BukuKu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 110, 176, 93),
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                          fontStyle: FontStyle.normal,
                        )),
                  ],
                ),
                const SizedBox(height: 100.0),
                SizedBox(
                    width: 340,
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: const TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 110, 176,
                                    93)), // Set the focused border color
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      style: const TextStyle(fontSize: 14),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a username'
                          : null,
                    )),
                const SizedBox(height: 24.0),
                SizedBox(
                    width: 340,
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 110, 176,
                                    93)), // Set the focused border color
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      style: const TextStyle(fontSize: 14),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 24.0),
                SizedBox(
                    width: 340,
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 110, 176,
                                    93)), // Set the focused border color
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      style: const TextStyle(fontSize: 14),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: 340,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      primary: const Color.fromARGB(
                          255, 110, 176, 93), // Set the button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String username = _usernameController.text;
                        String password = _passwordController.text;
                        String confirmPassword =
                            _confirmPasswordController.text;

                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Passwords do not match",
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                              ),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ),
                          );
                          return;
                        }

                        try {
                          if (password.length < 8) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Password must be at least 8 characters long",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 110, 176, 93),
                              ),
                            );
                            return;
                          }
                          if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])')
                              .hasMatch(password)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Password must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 110, 176, 93),
                              ),
                            );
                            return;
                          }

                          final response = await http.post(
                            Uri.parse(
                                'https://bukuku-d01-tk.pbp.cs.ui.ac.id/auth/register/'),
                            body: {
                              'username': username,
                              'password': password,
                            },
                          );

                          if (response.statusCode == 400) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Registration failed. Please try again.",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 110, 176, 93),
                              ),
                            );
                            // Navigate to login page or other screen
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Registration successful!",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 110, 176, 93),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }
                        } catch (e) {
                          print("Error during registration: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "An error occurred. Please try again later.",
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                              ),
                              backgroundColor:
                                  Color.fromARGB(255, 110, 176, 93),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      const TextSpan(
                        style: TextStyle(color: Colors.black),
                        //make link blue and underline
                        text: "already have an account? ",
                      ),
                      TextSpan(
                          style: const TextStyle(
                              color: Color.fromARGB(255, 110, 176, 93),
                              fontWeight: FontWeight.bold),
                          //make link blue and underline
                          text: "Log In",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            }),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

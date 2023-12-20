// ignore_for_file: use_build_context_synchronously

import 'package:bukuku/screens/product_page.dart';
import 'package:bukuku/screens/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 110, 176, 93),
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
              bottom: 16.0, left: 16.0, right: 16.0, top: 150),
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
              const SizedBox(height: 150.0),
              SizedBox(
                  width: 340,
                  child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: const TextStyle(fontSize: 14),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 110, 176,
                                  93)), // Set the focused border color
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color:
                                  Colors.grey), // Set the enabled border color
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      style: const TextStyle(fontSize: 14))),
              const SizedBox(height: 24.0),
              SizedBox(
                  width: 340,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 110, 176,
                                93)), // Set the focused border color
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.grey), // Set the enabled border color
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    obscureText: true,
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
                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    // Cek kredensial
                    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                    // Untuk menyambungkan Android emulator dengan Django pada localhost,
                    // gunakan URL http://10.0.2.2/
                    final response = await request.login(
                        "https://bukuku-d01-tk.pbp.cs.ui.ac.id/auth/login/", {
                      'username': username,
                      'password': password,
                    });

                    if (request.loggedIn) {
                      String message = response['message'];
                      String uname = response['username'];
                      int id = response['id'];
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookPage(id: id)));
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                            content: Text(
                              "$message Selamat datang, $uname.",
                              style: const TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1)),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 110, 176, 93)));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              const Color.fromARGB(255, 50, 81, 43),
                          title: const Text(
                            'Login Gagal',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          content: Text(response['message'],
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                          actions: [
                            TextButton(
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(TextSpan(
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                  children: [
                    const TextSpan(
                      style: TextStyle(color: Colors.black),
                      //make link blue and underline
                      text: "don`t have an account yet? ",
                    ),
                    TextSpan(
                        style: const TextStyle(
                            color: Color.fromARGB(255, 110, 176, 93),
                            fontWeight: FontWeight.bold),
                        //make link blue and underline
                        text: "Sign Up",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationPage()),
                            );
                          }),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}

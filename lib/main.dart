
import 'package:bukuku/screens/login.dart';
import 'package:bukuku/screens/product_page.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bukuku/screens/login.dart';
import 'package:bukuku/screens/menu.dart';
// /Users/joshuajodrian/repos/flutter/bin

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
            create: (_) {
                CookieRequest request = CookieRequest();
                return request;
            },

    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 110, 176, 93),),
        useMaterial3: true,
      ),
    home: const LoginPage(),
    ),
    );
  }
}

// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

List<Cart> cartFromJson(String str) =>
    List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<Cart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
  int user;
  int id;
  String bookTitle;
  String bookAuthor;
  double bookPrice;
  String bookImg;
  int bookAmount;

  Cart({
    required this.user,
    required this.id,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookPrice,
    required this.bookImg,
    required this.bookAmount,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        user: json["user"],
        id: json["id"],
        bookTitle: json["book_title"],
        bookAuthor: json["book_author"],
        bookPrice: json["book_price"]?.toDouble(),
        bookImg: json["book_img"],
        bookAmount: json["book_amount"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "id": id,
        "book_title": bookTitle,
        "book_author": bookAuthor,
        "book_price": bookPrice,
        "book_img": bookImg,
        "book_amount": bookAmount,
      };
}

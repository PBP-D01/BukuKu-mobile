// To parse this JSON data, do
//
//     final Checkout = CheckoutFromJson(jsonString);

import 'dart:convert';

List<Checkout> checkoutFromJson(String str) => List<Checkout>.from(json.decode(str).map((x) => Checkout.fromJson(x)));

String checkoutToJson(List<Checkout> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Checkout {
    String model;
    int pk;
    Fields fields;

    Checkout({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Checkout.fromJson(Map<String, dynamic> json) => Checkout(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String first_name;
    String last_name;
    String email;
    String address;

    Fields({
        required this.user,
        required this.first_name,
        required this.last_name,
        required this.email,
        required this.address,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        email: json["email"],
        address: json["address"]
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "address": address,
    };
}
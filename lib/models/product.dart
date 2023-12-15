// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    Model model;
    int pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    DateTime publishedDate;
    double price;
    String imgUrl;
    String author;
    String categoryName;
    double stars;
    int buys;

    Fields({
        required this.title,
        required this.publishedDate,
        required this.price,
        required this.imgUrl,
        required this.author,
        required this.categoryName,
        required this.stars,
        required this.buys,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        publishedDate: DateTime.parse(json["publishedDate"]),
        price: json["price"]?.toDouble(),
        imgUrl: json["imgUrl"],
        author: json["author"],
        categoryName: json["category_name"],
        stars: json["stars"]?.toDouble(),
        buys: json["buys"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "publishedDate": "${publishedDate.year.toString().padLeft(4, '0')}-${publishedDate.month.toString().padLeft(2, '0')}-${publishedDate.day.toString().padLeft(2, '0')}",
        "price": price,
        "imgUrl": imgUrl,
        "author": author,
        "category_name": categoryName,
        "stars": stars,
        "buys": buys,
    };
}

enum Model {
    BOOK_BOOK
}

final modelValues = EnumValues({
    "book.book": Model.BOOK_BOOK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}

import 'dart:convert';


class ProductWithReviews {
    int pk;
    ProductWithReviewFields fields;

    ProductWithReviews({
        required this.pk,
        required this.fields,
    });

    factory ProductWithReviews.fromJson(Map<String, dynamic> json) => ProductWithReviews(
        pk: json["pk"],
        fields: ProductWithReviewFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class ProductWithReviewFields {
    String title;
    String publishedDate;
    double price;
    String imgUrl;
    double stars;
    String category_name;
    String author;
    List<ProductReview> reviews;

    ProductWithReviewFields({
        required this.title,
        required this.publishedDate,
        required this.price,
        required this.imgUrl,
        required this.stars,
        required this.category_name,
        required this.author,
        required this.reviews,
    });

    factory ProductWithReviewFields.fromJson(Map<String, dynamic> json) => ProductWithReviewFields(
        title: json["title"],
        publishedDate: json["publishedDate"],
        price: json["price"],
        imgUrl: json["imgUrl"],
        stars: json["stars"],
        category_name: json["category_name"],
        author: json["author"],
        reviews: productReviewFromJson(jsonEncode(json["reviews"])),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "publishedDate": publishedDate,
        "price": price,
        "imgUrl": imgUrl,
        "stars": stars,
        "category_name": category_name,
        "author": author,
        "reviews": productReviewToJson(reviews),
    };
}



List<ProductReview> productReviewFromJson(String str) => List<ProductReview>.from(json.decode(str).map((x) => ProductReview.fromJson(x)));

String productReviewToJson(List<ProductReview> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductReview {
    int pk;
    ProductReviewFields fields;

    ProductReview({
        required this.pk,
        required this.fields,
    });

    factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
        pk: json["pk"],
        fields: ProductReviewFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class ProductReviewFields {
    String text;
    double rating;
    String book;
    String reviewer;

    ProductReviewFields({
        required this.text,
        required this.rating,
        required this.book,
        required this.reviewer,
    });

    factory ProductReviewFields.fromJson(Map<String, dynamic> json) => ProductReviewFields(
        text: json["text"],
        rating: json["rating"],
        book: json["book"],
        reviewer: json["reviewer"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "rating": rating,
        "book": book,
        "reviewer": reviewer,
    };
}
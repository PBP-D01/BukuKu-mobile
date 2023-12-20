
import 'dart:convert';
import 'package:bukuku/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:bukuku/models/product_review.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class ReviewPage extends StatefulWidget {
  final int id;
  final int user_id;

  const ReviewPage({super.key, required this.id, required this.user_id});
  @override
  // ignore: library_private_types_in_public_api
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late ProductWithReviews product;

  Future<ProductWithReviews> fetchProduct() async {
    final int id = widget.id;
    var url = Uri.parse('https://bukuku-d01-tk.pbp.cs.ui.ac.id/review/api/$id/get/');  //'https://bukuku-d01-tk.pbp.cs.ui.ac.id/review/api/$id/get/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    ProductWithReviews? result;
    result = ProductWithReviews.fromJson(data[0]);
    return result;
  }

  @override
  void initState() {
    super.initState();
    fetchProduct().then((product) {
      setState(() {
        product = product;
      });
    });
  }

  Future<void> postReview(String text, int rating) async {
    final int id = widget.id;
    final int user_id = widget.user_id;
    final String apiUrl = 'https://bukuku-d01-tk.pbp.cs.ui.ac.id/review/api/$id/post/review/';
    final Map<String, dynamic> requestData = {'text': text, 'rating': rating, 'user_id': user_id,};
    
    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print('Review berhasil dikirim!');
        setState(() {});
      } else {
        print(
            'Gagal menambahkan review. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int id = widget.id;
    return FutureBuilder<ProductWithReviews>(
      future: fetchProduct(),
      builder: (BuildContext context, AsyncSnapshot<ProductWithReviews> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(300),
            child: CircularProgressIndicator(),
          ); // Show loading spinner while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error if something went wrong
        } else {
          product = snapshot.data!; // Your product is now initialized
                return Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              titleSpacing: 0,
              title: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'BukuKu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
            drawer: LeftDrawer(id: id),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.fields.imgUrl,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                    child: Text(
                      product.fields.title,
                      style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.green,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Penulis: ${product.fields.author}",
                      style: const TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.normal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Tanggal Rilis: ${product.fields.publishedDate}",
                    style: const TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    '\$${product.fields.price}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5, bottom: 10),
                        child: Text(
                          '${product.fields.stars}'
                        ),
                      ),
                      RatingBarIndicator(
                        rating: product.fields.stars,
                        itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.green,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  )
                ),

                ElevatedButton(
                  onPressed: () {
                    TextEditingController controllerText = TextEditingController();
                    TextEditingController controllerRating = TextEditingController();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Review Buku'),
                          content: SizedBox(
                            height: 225,
                            width: 500,
                            child: Column(
                              children: <Widget>[
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  ),
                                  onRatingUpdate: (rating) {
                                    controllerRating.text = rating.toString();
                                  },
                                ),
                                TextField(
                                  controller: controllerText,
                                  decoration: InputDecoration(hintText: "Masukkan Review Anda"),
                                  maxLines: 6,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Kirim Review'),
                              onPressed: () async {
                                postReview(controllerText.text, int.parse(controllerRating.text));
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    'Review',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: product.fields.reviews.length,
                      itemBuilder: (context, index) {
                        return ReviewCard(
                          review: product.fields.reviews[index],
                        );
                      },
                    ),
                  )
                ),

              ],
            ),

            
          );
        }
      },
    );

    
  }
}

class ReviewCard extends StatelessWidget {
  final ProductReview review;

  const ReviewCard(
      {Key? key,
      required this.review,})
      : super(key: key);
      
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: Text(
              review.fields.reviewer,
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
              ),
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
            child: RatingBarIndicator(
              rating: review.fields.rating,
              itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.green,
              ),
              itemCount: 5,
              itemSize: 16.0,
              direction: Axis.horizontal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
            child: Text(
              review.fields.text,
              style: const TextStyle(
                  fontSize: 12.0,
              ),
              maxLines: 1,
            ),
          ),
        ]
      )
    );
  }

}
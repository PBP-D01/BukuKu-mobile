import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bukuku/models/product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late List<Product> filteredProducts;
  String dropdownValue = 'Title';

  Future<List<Product>> fetchProducts() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Product> listProducts = [];
    for (var d in data) {
      if (d != null) {
        listProducts.add(Product.fromJson(d));
      }
    }
    return listProducts;
  }

  @override
  void initState() {
    super.initState();
    filteredProducts = [];
    fetchProducts().then((products) {
      setState(() {
        filteredProducts = products;
      });
    });
  }

  void filterProducts(String query) async {
    setState(() {
      if (query.isEmpty) {
        // Jika query kosong, tampilkan semua produk
        fetchProducts().then((products) {
          setState(() {
            filteredProducts = products;
          });
        });
      } else {
        // Lakukan filter sesuai dengan query
        filteredProducts = filteredProducts
            .where((product) =>
                ((dropdownValue == 'Title') &&
                    product.fields.title
                        .toLowerCase()
                        .contains(query.toLowerCase())) ||
                ((dropdownValue == 'Author') &&
                    product.fields.author
                        .toLowerCase()
                        .contains(query.toLowerCase())) ||
                ((dropdownValue == 'Year') &&
                    product.fields.publishedDate.year
                        .toString()
                        .contains(query)))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: filterProducts,
                    decoration: InputDecoration(
                      labelText: 'Temukan Buku yang Anda Cari',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    }
                  },
                  items: <String>['Title', 'Author', 'Year']
                      .map<DropdownMenuItem<String>>((String value) {
                    IconData icon;
                    if (value == 'Title') {
                      icon = Icons.title;
                    } else {
                      icon = Icons.filter_alt;
                    }

                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Icon(icon),
                          SizedBox(width: 8),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return BookCard(product: filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Product product;

  const BookCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            padding: const EdgeInsets.all(8.0),
            child: Flexible(
              child: Text(
                product.fields.title,
                style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            ),
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flexible(
            child: Text(
              product.fields.author,
              style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.fields.publishedDate.year.toString(),
              style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()))
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Review()));
                },
                child: Text(
                  'Review',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
            ],
          ),
        ],
        ),
    );
  }
}

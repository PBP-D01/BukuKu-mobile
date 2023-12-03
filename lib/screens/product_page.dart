import 'package:flutter/material.dart';

void main() {
  runApp(BookScreen());
}

class Book {
  final String title;
  final String author;
  // final String coverUrl;

  Book({required this.title, required this.author});
}

class BookScreen extends StatelessWidget {
  final List<Book> books = [
    Book(title: 'Flutter in Action', author: 'Eric Windmill'),
    Book(title: 'Flutter in Action', author: 'Eric Windmill'),
    Book(title: 'Flutter in Action', author: 'Eric Windmill'),
    Book(title: 'Flutter in Action', author: 'Eric Windmill'),
    Book(title: 'Flutter in Action', author: 'Eric Windmill'),
    Book(title: 'Flutter in Action', author: 'Eric Windmill'),
    Book(title: 'Flutter in Action', author: 'Eric Windmill'),

  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Book List'),
          backgroundColor: Colors.green,
        ),
        body: BookList(books: books),
      ),
    );
  }
}

class BookList extends StatefulWidget {
  final List<Book> books;

  const BookList({Key? key, required this.books}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  late List<Book> filteredBooks;
  String dropdownValue = 'Title';

  @override
  void initState() {
    super.initState();
    filteredBooks = widget.books;
  }

  void filterBooks(String query) {
    setState(() {
      filteredBooks = widget.books
          .where((book) =>
              ((dropdownValue == 'Title') && book.title.toLowerCase().contains(query.toLowerCase())) ||
              ((dropdownValue == 'Author') && book.author.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: filterBooks,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    hintText: 'Search by ${dropdownValue.toLowerCase()}',
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
                items: <String>['Title', 'Author'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              return BookCard(book: filteredBooks[index]);
            },
          ),
        ),
      ],
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(book.coverUrl, width: 120, height: 120),
            SizedBox(height: 8),
            Text(
              book.title,
              style: TextStyle(fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 4),
            Text('Author: ${book.author}'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, 
                  ),
                  child: Text('Add to Cart'),
                  
                  
                ),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: Text('Review'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, 
                  ),
                  
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

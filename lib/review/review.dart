import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bukuku'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReviewPage()),
            );
          },
          child: Text('Buka Review Page'),
        ),
      ),
    );
  }
}

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double rating = 0;
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bukuku - Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Beri nilai:'),
                SizedBox(width: 16),
                RatingBar(
                  onRatingChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: 'Tulis review Anda',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Proses pengiriman review
                if (rating > 0 && reviewController.text.isNotEmpty) {
                  // Tambahkan logika untuk menyimpan review
                  // Misalnya, menampilkan review dalam bentuk card
                  _showReviewCard();
                } else {
                  // Tampilkan pesan kesalahan jika input tidak valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mohon beri nilai dan tulis review Anda.'),
                    ),
                  );
                }
              },
              child: Text('Kirim'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewCard() {
    // Tampilkan review dalam bentuk card
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Review Anda'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rating: $rating'),
              SizedBox(height: 8),
              Text('Review: ${reviewController.text}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

class RatingBar extends StatelessWidget {
  final Function(double) onRatingChanged;

  const RatingBar({required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => IconButton(
          onPressed: () {
            // Nilai bintang yang dipilih adalah index + 1
            onRatingChanged(index + 1.0);
          },
          icon: Icon(
            index < (onRatingChanged(0) ?? 0).toInt() ? Icons.star : Icons.star_border,
          ),
        ),
      ),
    );
  }
}

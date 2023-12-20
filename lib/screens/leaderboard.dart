import 'dart:convert';

import 'package:bukuku/models/leaderboard_comments_model.dart';
import 'package:bukuku/models/leaderboard_model.dart';
import 'package:flutter/material.dart';
import 'package:bukuku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatefulWidget {
  final int id;

  const LeaderboardPage({super.key, required this.id});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    final int id = widget.id;
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Leaderboard',
        ),
        backgroundColor: Color.fromARGB(255, 110, 176, 93),
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(id: id),
      // body: Column(children: [Leaderboard()]),
      body: Column(children: [Leaderboard(), CommentSection(id: id)]),
    );
  }
}

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Future<List<BookLeaderboard>> data = request
        .get("https://bukuku-d01-tk.pbp.cs.ui.ac.id/leaderboard/get_leaderboard_flutter/")
        .then((value) {
      if (value == null) {
        return [];
      }
      // print(value);
      var jsonValue = jsonDecode(value);
      // print("JS VAL $jsonValue");
      // print("JS VAL ${jsonValue['text']}");
      List<BookLeaderboard> listItem = [];
      for (var data in jsonValue) {
        if (data != null) {
          listItem.add(BookLeaderboard.fromJson(data));
        }
      }
      return listItem;
    });
    return Container(
      height: (MediaQuery.of(context).size.height) *
          0.65, // Set a specific height or use a percentage
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: data,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 10,
                  columns: [
                    DataColumn(label: Text('Ranking')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Author')),
                    DataColumn(label: Text('Stars')),
                    DataColumn(label: Text('Buys')),
                  ],
                  rows: List<DataRow>.generate(
                    snapshot.data.length,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(
                          SizedBox(
                            width: (MediaQuery.of(context).size.height) * 0.2,
                            child: Text(
                              snapshot.data[index].fields.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(
                          snapshot.data[index].fields.price.toString(),
                        )),
                        DataCell(
                            Text(snapshot.data[index].fields.author ?? '')),
                        DataCell(Text(
                          snapshot.data[index].fields.stars.toString(),
                        )),
                        DataCell(Text(
                          snapshot.data[index].fields.buys.toString(),
                        )),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CommentSection extends StatelessWidget {
  final int id;

  const CommentSection({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final controller = TextEditingController();
    Future<List<Comment>> data = request
        .get(
            "https://bukuku-d01-tk.pbp.cs.ui.ac.id/leaderboard/get_comment_flutter/")
        .then((value) {
      if (value == null) {
        return [];
      }
      var jsonValue = jsonDecode(value);
      // print("JS VAL ${jsonValue['text']}");
      List<Comment> listItem = [];
      for (var data in jsonValue) {
        if (data != null) {
          listItem.add(Comment.fromJson(data));
        }
      }

      return listItem;
    });

    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Comments',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          // Display comments here
          CommentTile('Great leaderboard!'),
          FutureBuilder(
              future: data,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData) {
                    return const Column(
                      children: [
                        Text(
                          "Tidak ada data produk.",
                          style:
                              TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 12),
                            child: CommentTile(
                                snapshot.data[index].fields.comment)));
                  }
                }
              })
          // Add more CommentTile widgets as needed
          ,
          SizedBox(height: 16.0),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  var response = await request.postJson(
                      "https://bukuku-d01-tk.pbp.cs.ui.ac.id/leaderboard/create_comment_flutter/",
                      jsonEncode(<String, String>{'comment': controller.text}));
                  // tiru github gw3
                  controller.clear();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeaderboardPage(id: id)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Comment> list_comment = [];

class CommentTile extends StatelessWidget {
  final String comment;

  CommentTile(this.comment);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(comment),
      ),
    );
  }
}

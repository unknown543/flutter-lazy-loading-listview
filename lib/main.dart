import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './model/post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazy Loading ListView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  static const url = "https://jsonplaceholder.typicode.com/posts/1/comments";
  List<Post> posts = [];
  int index = 3;
  ScrollController _scrollController = ScrollController();
  Future<void> fetchData() async {
    var response = await http.get(url);
    var decodedJson = json.decode(response.body);
    decodedJson.map((data) => posts.add(Post.fromJson(data))).toList();
    var response1 =
        await http.get("https://jsonplaceholder.typicode.com/posts/2/comments");
    var decodedJson1 = json.decode(response1.body);
    decodedJson1.map((data) => posts.add(Post.fromJson(data))).toList();
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) fetMoreData();
    });
    super.initState();
  }

  Future<void> fetMoreData() async {
    var response1 = await http
        .get("https://jsonplaceholder.typicode.com/posts/$index/comments");
    var decodedJson1 = json.decode(response1.body);
    decodedJson1.map((data) => posts.add(Post.fromJson(data))).toList();
    index++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lazy Loading ListView")),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
            controller: _scrollController,
              itemCount: posts.length + 1,
              itemBuilder: (BuildContext ctx, int i) => i == posts.length
                  ? Center(child: CircularProgressIndicator())
                  : Card(
                      child: ListTile(
                        leading:
                            CircleAvatar(child: Text("#${posts[i].postId}")),
                        title: Text("id ${posts[i].id}"),
                        subtitle: Text("${posts[i].email}"),
                      ),
                    ),
            ),
    );
  }
}

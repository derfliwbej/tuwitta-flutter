import 'package:flutter/material.dart';

import './ViewPostArguments.dart';
import '../models/PostModel.dart';
import '../models/CommentModel.dart';

import '../utils/secure_storage.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewPostPage extends StatefulWidget {
  static const routeName = '/viewPost';

  const ViewPostPage({Key? key}) : super(key: key);

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  final replyFieldController = TextEditingController();
  final List<Comment> comments = [];

  @override
  void dispose() {
    super.dispose();

    replyFieldController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void addReply(Comment comment) {
    setState(() {
      comments.add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ViewPostArguments;

    final post = args.post;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFF15202b)
        ),
        body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        children: [
                          PostWidget(post: post),
                          const Divider(height: 1.0, color: Color(0xFF425364)),
                          CommentsList(post: post, comments: comments)
                        ]
                    )
                ),
              ),
              ReplyField(post: post, comments: comments, addReply: addReply)
            ]
        )
    );
  }
}

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.withOpacity(0.0),
                backgroundImage: AssetImage("assets/user_icon.jpg"),
              ),
              SizedBox(width: 15.0),
              Text(post.username, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ]
          ),
          SizedBox(height: 15.0),
          Text(post.text, style: const TextStyle(fontSize: 16.0)),
        ],
      )
    );
  }
}

class CommentsList extends StatefulWidget {
  final Post post;
  final List<Comment> comments;

  const CommentsList({Key? key, required this.post, required this.comments}) : super(key: key);

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  bool isLoading = false;
  bool hasMore = true;

  Future getInitialComments() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final limit = 30;
    final token = await SecureStorage.getToken();
    final postId = widget.post.id;

    final res = await http.get(
        Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/comment/$postId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    if(res.statusCode == 200) {
      List<Comment> comments = jsonDecode(res.body)["data"].map<Comment>((comment) {
        return Comment.fromJson(comment);
      }).toList();

      if(comments.length < limit) {
        setState(() {
          hasMore = false;
        });
      }

      setState(() {
        widget.comments.addAll(comments);
        isLoading = false;
      });
    } else {
      print("ERROR RETRIEVING COMMENTS");
    }
  }

  @override
  void initState() {
    getInitialComments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final comments = widget.comments;
    int commentCount = 0;

    return !isLoading ? Column(
        children: comments.map<CommentItem>((comment) {
          return CommentItem(comment: comment);
        }).toList()
    ) : CircularProgressIndicator();
  }
}

class ReplyField extends StatefulWidget {
  final Post post;
  final List<Comment> comments;
  final Function addReply;

  const ReplyField({ Key? key, required this.post, required this.comments, required this.addReply }) : super(key: key);

  @override
  State<ReplyField> createState() => _ReplyFieldState();
}

class _ReplyFieldState extends State<ReplyField> {
  final replyFieldController = TextEditingController();
  bool isAddingComment = false;

  Future addComment(String postId) async {
    if(isAddingComment) return;

    setState(() {
      isAddingComment = true;
    });

    final token = await SecureStorage.getToken();

    final res = await http.post(
      Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/comment/$postId"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        "text": replyFieldController.text
      })
    );

    if(res.statusCode == 200) {
      Comment newComment = Comment.fromJson(jsonDecode(res.body)["data"]);

      widget.addReply(newComment);

      setState(() {
        isAddingComment = false;
      });
    } else {
      print("ERROR ADDING COMMENT");
    }

    replyFieldController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Post post = widget.post;

    InputDecoration commentInputStyle = const InputDecoration(
        hintText: 'Tweet your reply',
        hintStyle: TextStyle(color: Color(0xFF53687e)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue
            )
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF425364),
            )
        )
    );

    ButtonStyle replyButtonStyle = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
            )
        )
    );

    return Container(
        padding: EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            color: const Color(0xFF15202b),
            border: Border(
                top: BorderSide(
                  color: const Color(0xFF425364),
                  width: 1.0,
                )
            )
        ),
        child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Replying to ",
                            style: TextStyle(color: Color(0xFF53687e), fontSize: 16.0),
                            children: [
                              TextSpan(text: "@${post.username}", style: TextStyle(color: Colors.blue, fontSize: 16.0))
                            ]
                        )
                    ),
                    ElevatedButton(
                        child: const Text('Reply', style: const TextStyle(fontSize: 16.0)),
                        onPressed: () {
                          // Comment newComment = new Comment(id: "asd", text: "asd", postId: "asd", username: "asd", date: 123);
                          // widget.mockReply(newComment);
                          addComment(widget.post.id);
                        },
                        style: replyButtonStyle
                    )
                  ]
              ),
              TextField(decoration: commentInputStyle, keyboardType: TextInputType.multiline, controller: replyFieldController, maxLines: null),
            ]
        )
    );
  }
}

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({ Key? key, required this.comment }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey<String>(comment.id),
      title: Text(comment.username, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(comment.text, style: const TextStyle(color: Colors.white)),
    );
  }
}


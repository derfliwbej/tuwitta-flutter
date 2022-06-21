import 'package:flutter/material.dart';

import './ViewPostArguments.dart';
import '../models/PostModel.dart';

class ViewPostPage extends StatefulWidget {
  static const routeName = '/viewPost';

  const ViewPostPage({Key? key}) : super(key: key);

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  final replyFieldController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    replyFieldController.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                          CommentsList()
                        ]
                    )
                ),
              ),
              ReplyField(post: post)
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
                child: Image.asset("assets/images/user_icon.png"),
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

  const CommentsList({Key? key}) : super(key: key);

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ReplyField extends StatefulWidget {
  final Post post;

  const ReplyField({Key? key, required this.post}) : super(key: key);

  @override
  State<ReplyField> createState() => _ReplyFieldState();
}

class _ReplyFieldState extends State<ReplyField> {
  final replyFieldController = TextEditingController();

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
                        onPressed: () {},
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



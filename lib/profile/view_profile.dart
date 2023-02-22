import 'package:flutter/material.dart';
import './ViewProfileArguments.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/secure_storage.dart';

import '../models/PostModel.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({Key? key}) : super(key: key);

  static const routeName = '/viewProfile';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ViewProfileArguments;

    final username = args.username;
    final firstName = args.firstName;
    final lastName = args.lastName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xFF15202b)
      ),
      body: ListView(
        children: [
          ProfileHeader(username: username, firstName: firstName, lastName: lastName),
          const Divider(height: 1, thickness: 1, color: Color(0xFF425364)),
          UserPosts(username: username)
        ]
      )

    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String username;
  final String firstName;
  final String lastName;

  const ProfileHeader({Key? key, required this.username, required this.firstName, required this.lastName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.withOpacity(0.0),
                backgroundImage: AssetImage("assets/profile_icon.png"),
              ),
              Text(
                '@$username',
                style: TextStyle(fontSize: 16.0, color: Color(0xFF71767B))
              ),
              SizedBox(height: 10.0),
              Text(
                '$firstName $lastName',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ]
        )
    );
  }
}

class UserPosts extends StatefulWidget {
  final String username;

  const UserPosts({Key? key, required this.username}) : super(key: key);

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  String currentUser = "";
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  List<Post> _currentPosts = [];
  bool hasMore = true;

  Future getInitialPosts() async {
    if(isLoading) return;

    setState(() {
      isLoading = true;
    });

    final limit = 30;
    final token = await SecureStorage.getToken();
    String username = widget.username;

    final res = await http.get(
        Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post?limit=$limit&username=$username"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if(res.statusCode == 200) {
      List<Post> postsList = jsonDecode(res.body)["data"].map<Post>((post) {
        return Post.fromJson(post);
      }).toList();

      if(postsList.length < limit) {
        setState(() {
          hasMore = false;
        });
      }

      postsList.removeWhere((post) => !post.public);

      if(postsList.isEmpty) {
        setState(() {
          hasMore = false;
        });
      }

      setState(() {
        isLoading = false;
        _currentPosts.addAll(postsList);
      });

      print(isLoading);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setCurrentUser() async {
    String username = await SecureStorage.getUsername() as String;

    setState( () {
      currentUser = username;
    });
  }

  @override
  void initState() {
    getInitialPosts();
    setCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: !isLoading ? ListView.separated(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: _currentPosts.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if(index < _currentPosts.length) {
                return PostItem(post: _currentPosts[index], currentUser: currentUser);
              } else {
                return Padding(padding: EdgeInsets.only(top: 15.0, bottom: 15.0), child: Center(child: hasMore && isLoading ? CircularProgressIndicator() : Container()));
              }
            },
            separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Color(0xFF425364))
        ) : Center(child: CircularProgressIndicator())
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;
  final String currentUser;

  const PostItem({ Key? key, required this.post, required this.currentUser }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        key: ValueKey<String>(post.id),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.blue.withOpacity(0.0),
          backgroundImage: AssetImage("assets/user_icon.jpg"),
        ),
        title: Text(post.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        subtitle: Text(post.text, style: TextStyle(color: Colors.white)),
        trailing: currentUser == post.username ? FittedBox(
          child: Row(
            children: [
              IconButton(
                icon: Icon(FontAwesomeIcons.pencil),
                color: Colors.white,
                onPressed: () {
                  // TODO: Logic for editing post
                }
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.trash),
                color: Colors.white,
                onPressed: () {
                  // TODO: Logic for deleting post
                }
              )
            ]
          )
        ) : const FittedBox()
    );
  }
}

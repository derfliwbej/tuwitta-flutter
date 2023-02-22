import 'package:flutter/material.dart';
import './ViewProfileArguments.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/secure_storage.dart';
import '../utils/message_dialog.dart';

import '../models/PostModel.dart';

/**
 * Edit a post given the post's id and the new text
 *
 * @param id        The id of the post to edit
 * @param body      The new text of the post to edit
 *
 * @return          A HTTP response of the PUT request
 */
Future<http.Response> editPost(String id, String body) async {
  final token = await SecureStorage.getToken();

  return http.put(
      Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, Object>{
        "text": body,
        "public": true,
      })
  );
}

/**
 * Delete a post given the post's id
 *
 * @param id        The id of the post to edit
 *
 * @return          A HTTP response of the DELETE request
 */
Future<http.Response> deletePost(String id) async {
  final token = await SecureStorage.getToken();

  return http.delete(
      Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
}

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

  // Gets the posts on initial render
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
        _currentPosts = postsList;
      });

    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Set the current user on this widget's state to the value of the username in the secure storage
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
                return PostItem(post: _currentPosts[index], currentUser: currentUser, getPosts: getInitialPosts);
              } else {
                return Padding(padding: EdgeInsets.only(top: 15.0, bottom: 15.0), child: Center(child: hasMore && isLoading ? CircularProgressIndicator() : Container()));
              }
            },
            separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Color(0xFF425364))
        ) : Center(child: CircularProgressIndicator())
    );
  }
}

class PostItem extends StatefulWidget {
  final Post post;
  final String currentUser;
  final Function() getPosts;

  const PostItem({Key? key, required this.post, required this.currentUser, required this.getPosts }) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  TextEditingController _editTextFieldController = TextEditingController();

  // Create an InputDecoration instance for a text field given a label
  InputDecoration textFieldStyle(String label) {
    return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: const Color(0xFF425364)),
        hintStyle: TextStyle(color: const Color(0xFF425364)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            )
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF425364),
            )
        )
    );
  }

  /// Shows the input dialog for editing a post.
  ///
  /// @param context         The Build Context of the widget where this function is called from.
  /// @param postId          The id of the post to edit
  ///
  /// @return                A showDialog widget
  Future<void> _displayEditInputDialog(BuildContext context, String postId) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Enter new text'),
              backgroundColor: const Color(0xFF15202b),
              content: TextField(
                controller: _editTextFieldController,
                decoration: textFieldStyle('New text'),
              ),
              actions: <Widget>[
                ElevatedButton(
                    child: Text('CANCEL'),
                    onPressed: () {
                      _editTextFieldController.clear();
                      Navigator.pop(context);
                    }
                ),
                ElevatedButton(
                    child: const Text('SAVE'),
                    onPressed: () async {
                      String body = _editTextFieldController.text;

                      http.Response res = await editPost(postId, body);

                      if(res.statusCode == 200) {
                        _editTextFieldController.clear();

                        widget.getPosts();
                      } else {
                        displayMessageDialog(context, "Error", "Error editing post.");
                        _editTextFieldController.clear();
                      }

                      Navigator.pop(context);
                    }
                )
              ]
          );
        }
    );
  }

  /// Shows the confirm dialog for deleting a post.
  ///
  /// @param context         The Build Context of the widget where this function is called from.
  /// @param postId          The id of the post to delete
  ///
  /// @return                A showDialog widget
  Future<void> _displayConfirmDeleteDialog(BuildContext context, String postId) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Delete Confirmation'),
              backgroundColor: const Color(0xFF15202b),
              content: const Text('Are you sure you want to delete this post?'),
              actions: <Widget>[
                ElevatedButton(
                    child: Text('CANCEL'),
                    onPressed: () {
                      _editTextFieldController.clear();
                      Navigator.pop(context);
                    }
                ),
                ElevatedButton(
                    child: const Text('DELETE'),
                    onPressed: () async {
                      http.Response res = await deletePost(postId);

                      if(res.statusCode == 200) {
                        widget.getPosts();
                      } else {
                        displayMessageDialog(context, "Error", "Error deleting post.");
                      }

                      Navigator.pop(context);
                    }
                )
              ]
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        key: ValueKey<String>(widget.post.id),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.blue.withOpacity(0.0),
          backgroundImage: AssetImage("assets/user_icon.jpg"),
        ),
        title: Text(widget.post.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        subtitle: Text(widget.post.text, style: TextStyle(color: Colors.white)),
        trailing: widget.currentUser == widget.post.username ? FittedBox(
            child: Row(
                children: [
                  IconButton(
                      icon: Icon(FontAwesomeIcons.pencil),
                      color: Colors.white,
                      onPressed: () {
                        _displayEditInputDialog(context, widget.post.id);
                      }
                  ),
                  IconButton(
                      icon: Icon(FontAwesomeIcons.trash),
                      color: Colors.white,
                      onPressed: () {
                        _displayConfirmDeleteDialog(context, widget.post.id);
                      }
                  )
                ]
            )
        ) : const FittedBox()
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import '../profile/view_profile.dart';
import '../profile/ViewProfileArguments.dart';
import '../profile/edit_profile.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/secure_storage.dart';
import '../utils/route_observer.dart';

import '../models/PostModel.dart';

Future<http.Response> authRequest() async {
  final token = await SecureStorage.getToken();

  return http.get(
    Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/user"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
}

Future<void> logout() async {
  final token = await SecureStorage.getToken();

  await SecureStorage.deleteToken();

  final res = await http.post(
    Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/logout"),
    headers: {
      'Authorization': 'Bearer $token'
    }
  );

  print("Logout status: ${res.statusCode}");
}

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String? username;
  List<Post> _currentPosts = [];
  ScrollController _scrollController = ScrollController();
  bool hasMore = true;
  bool isLoading = false;

  @override
  void initState() {
    getInitialPosts();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        addPosts();
      }
    });
    super.initState();
  }

  Future getInitialPosts() async {
    if(isLoading) return;
    isLoading = true;

    final limit = 30;
    final token = await SecureStorage.getToken();

    final res = await http.get(
      Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post?limit=$limit"),
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

      if(postsList.length == 0) {
        setState(() {
          hasMore = false;
        });
      }

      setState(() {
        isLoading = false;
        _currentPosts.addAll(postsList);
      });
    }
  }

  Future addPosts() async {
    if (isLoading) return;
    isLoading = true;

    final limit = 15;
    final token = await SecureStorage.getToken();
    String lastPostId = _currentPosts[_currentPosts.length - 1].id;

    final res = await http.get(
        Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post?limit=$limit&next=$lastPostId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    print(res.statusCode);

    if(res.statusCode == 200) {
      List<Post> newPosts = jsonDecode(res.body)["data"].map<Post>((post) {
        return Post.fromJson(post);
      }).toList();

      if(newPosts.length < limit) {
        setState(() {
          hasMore = false;
        });
      }

      newPosts.removeWhere((post) => !post.public);

      if(newPosts.isEmpty) {
        setState(() {
          hasMore = false;
        });
      }

      setState(() {
        isLoading = false;
        _currentPosts.addAll(newPosts);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue.withOpacity(0.0),
              child: Image.asset("assets/images/profile_icon.png"),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: const Color(0xFF15202b),
        bottom: PreferredSize(
          child: Container(
            color: const Color(0xFF425364),
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(1.0),
        ),
        title: const Icon(
            FontAwesomeIcons.twitter,
            color: Colors.white,
        )
      ),
      body: SafeArea(
        child: _currentPosts.isNotEmpty ? ListView.separated(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: _currentPosts.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if(index < _currentPosts.length) {
              return PostItem(post: _currentPosts[index]);
            } else {
              return Padding(padding: EdgeInsets.only(top: 15.0, bottom: 15.0), child: Center(child: hasMore ? CircularProgressIndicator() : Container()));
            }
          },
          separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Color(0xFF425364))
        ) : Center(child: CircularProgressIndicator())
      )
    );
  }
}

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>  with RouteAware {
  String? username;
  String? firstName;
  String? lastName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Observer.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    init();
  }

  @override
  void initState(){
    super.initState();

    init();
  }

  void init() async {
    final username = await SecureStorage.getUsername();
    final firstName = await SecureStorage.getFirstName();
    final lastName = await SecureStorage.getLastName();

    print("INITIALIZED");

    setState(() {
      this.username = username;
      this.firstName = firstName;
      this.lastName = lastName;
    });
  }

  @override
  void dispose() {
    Observer.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle listTextStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );

    return Drawer(
        backgroundColor: const Color(0xFF15202b),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.withOpacity(0.0),
                        child: Image.asset("assets/images/profile_icon.png"),
                      ),
                      SizedBox(height: 10.0),
                      Text('@$username'),
                      SizedBox(height: 10.0),
                      Text('$firstName $lastName', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    ]
                )
            ),
            ListTile(
                title: Text('View Profile', style: listTextStyle),
                leading: Icon(Icons.account_box, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      ViewProfilePage.routeName,
                      arguments: ViewProfileArguments(
                          username!, firstName!, lastName!
                      )
                  );
                }
            ),
            ListTile(
                title: Text('Edit Profile', style: listTextStyle),
                leading: Icon(CupertinoIcons.pencil, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      EditProfilePage.routeName
                  );
                }
            ),
            ListTile(
                title: Text('Logout', style: listTextStyle),
                leading: Icon(CupertinoIcons.back, color: Colors.white),
                onTap: () {
                  logout();
                  Navigator.pushNamed(context, '/');
                }
            ),
          ],
        )
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey<String>(post.id),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.blue.withOpacity(0.0),
        child: Image.asset("assets/images/user_icon.png"),
      ),
      title: Text(post.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
      subtitle: Text(post.text, style: TextStyle(color: Colors.white)),
    );
  }
}

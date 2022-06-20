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
  Future<List<Post>>? _currentPosts;

  @override
  void initState() {
    _currentPosts = getInitialPosts();
    super.initState();
  }

  Future<void> _showDialog(int statusCode) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF15202b),
          title: const Text('Status Code'),
          content: Text('Status code is $statusCode'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              }
            )
          ]
        );
      }
    );
  }

  Future<List<Post>> getInitialPosts() async {
    final token = await SecureStorage.getToken();

    final res = await http.get(
      Uri.parse("https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post?limit=15"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

    if(res.statusCode == 200) {
      List<Post> postsList = jsonDecode(res.body)["data"].map<Post>((post) {
        return Post.fromJson(post);
      }).toList();

      postsList.removeWhere((post) => !post.public);

      return postsList;
    } else {
      List<Post> list = [];
      return list;
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
        child: FutureBuilder<List<Post>>(
          future: _currentPosts,
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if(snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) => PostItem(post: snapshot.data![index]),
                separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Color(0xFF425364))
              );
            } else if(snapshot.hasError) {
              print(snapshot.error);
              return Text('Error');
            } else {
              return CircularProgressIndicator();
            }
          }
        )
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

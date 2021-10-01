import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page/Components/admin_home_page.dart';
import 'package:fan_page/Components/user_home_page.dart';
import 'package:fan_page/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Screen'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () async {
              _userLogout(context);
            },
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'LOGOUT',
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder(
        stream: DatabaseService(uid: _auth.currentUser!.uid).user,
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              );
            default:
              return checkRole(snapshot.data);
          }
        },
      ),
    );
  }
}

Widget checkRole(DocumentSnapshot<Object?>? data) {
  if (data!['admin']) {
    return const AdminHomePage();
  } else {
    return const UserHomePage();
  }
}

Future<void> _userLogout(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('YES'),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.blueGrey,
                      content: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'User successfully logged out.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      duration: Duration(seconds: 5),
                    ),
                  );
                  if (_auth.currentUser == null) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (_) => false);
                  }
                } catch (error) {
                  throw ErrorDescription(error.toString());
                }
              },
            ),
          ],
        );
      });
}

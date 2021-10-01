import 'package:fan_page/services/database.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        onPressed: () async {
          _getPostInfo(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'Create New Post',
        backgroundColor: Colors.green,
      ),
    );
  }
}

Future<void> _getPostInfo(BuildContext context) async {
  String body = '';
  String title = '';
  final _formkey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Post Info'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width * .7,
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        title = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                      cursorColor: Colors.black,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: 'Title',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        body = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: 'Body',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
              child: const Text('POST'),
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  try {
                    await DatabaseService().addPost(title, body);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blueGrey,
                        content: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Post Successfully Created',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        duration: Duration(seconds: 5),
                      ),
                    );
                    Navigator.of(context).pop();
                  } catch (error) {
                    throw ErrorDescription(error.toString());
                  }
                }
              },
            ),
          ],
        );
      });
}

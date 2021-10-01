import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page/Components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';

class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen({Key? key}) : super(key: key);

  @override
  _RegisterInfoScreenState createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  final formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  String fName = '';
  String lName = '';
  String date = '';
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formkey,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 120),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 80),
                            TextFormField(
                              onChanged: (value) {
                                fName = value.toString().trim();
                              },
                              validator: (value) => (value!.isEmpty)
                                  ? ' Please enter First Name'
                                  : null,
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'First Name',
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              onChanged: (value) {
                                lName = value.toString().trim();
                              },
                              validator: (value) => (value!.isEmpty)
                                  ? ' Please enter Last Name'
                                  : null,
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Last Name',
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            const SizedBox(height: 80),
                            LoginSignupButton(
                              title: 'Complete Additional Info',
                              ontapp: () async {
                                if (formkey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  try {
                                    await _users
                                        .doc(_auth.currentUser!.uid)
                                        .set({
                                      'f_name': fName,
                                      'l_name': lName,
                                      'creation_date': DateTime.now(),
                                      'admin': false
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.blueGrey,
                                        content: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Additional User Info Stored.',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/home', (_) => false);

                                    setState(() {
                                      isloading = false;
                                    });
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(
                                          'Uh Oh! Registration Failed',
                                        ),
                                        content: Text(
                                          '$e',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: const Text('Okay'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

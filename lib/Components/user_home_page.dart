import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page/services/database.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().posts,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
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
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Center(
                  child: Material(
                    elevation: 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 6,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              doc['title'],
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(doc['body']),
                          ],
                        ),
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(width: 2.5, color: Colors.black),
                            right: BorderSide(width: 2.5, color: Colors.black),
                            bottom:
                                BorderSide(width: 2.5, color: Colors.black)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

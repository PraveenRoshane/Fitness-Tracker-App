import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/models/weight_modal.dart';
import 'package:flutter_new/screens/authentication/login_page.dart';
import 'package:flutter_new/screens/home/home.dart';
import 'package:flutter_new/screens/weightTracker/add_weight.dart';
import 'package:flutter_new/screens/weightTracker/update_weight.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_new/screens/weightTracker/search.dart';
import 'dart:developer';
import 'package:flutter_new/screens/weightTracker/widget/search_bar.dart';






class SearchBar extends StatelessWidget {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('weights');
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        title: const Text('Weight List',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Theme
                        .of(context)
                        .primaryColor,
                    Theme
                        .of(context)
                        .colorScheme
                        .secondary,
                  ])),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Container(
              child: InkWell(
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ));
                },
              ),
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [
                    0.0,
                    1.0
                  ],
                  colors: [
                    Theme
                        .of(context)
                        .primaryColor
                        .withOpacity(0.2),
                    Theme
                        .of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                  ])),

          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors: [
                      Theme
                          .of(context)
                          .primaryColor,
                      Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                    ],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: const Text(
                    "Weight Tracker",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home_rounded,
                  size: _drawerIconSize,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ),
              Divider(
                color: Theme
                    .of(context)
                    .primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: _drawerIconSize,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme
                    .of(context)
                    .primaryColor,
                Theme
                    .of(context)
                    .colorScheme
                    .secondary,
              ]),
          image: const DecorationImage(
            image: AssetImage("assets/images/weightlift.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: FutureBuilder<QuerySnapshot>(
          future: _reference.get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;

              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              // Convert data to List
              List<Weight> weights = documents
                  .map((e) =>
                  Weight(
                    id: e['id'],
                    age: e['age'],
                    date: e['date'],
                    weight: e['weight'],))
                  .toList();
              return _getBody(weights);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddWeight()));
        }),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
  Widget _getBody(weights) {
    return weights.isEmpty
        ? const Center(
      child: Text(
        'No Weight Yet\nClick + to start adding',
        textAlign: TextAlign.center,
      ),
    )
        : ListView.builder(
      itemCount: weights.length,
      itemBuilder: (context, index) => Card(
        color: weights[index].weight < 40
            ? Colors.yellow
            : weights[index].weight > 90
            ? Colors.red
            : Colors.green,
        child: ListTile(
          title:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(weights[index].date),

            ],
          ),
          subtitle: Text('Age: ${weights[index].age}'),
          leading: CircleAvatar(
            radius: 25,
            child: Text('${weights[index].weight}'),

          ),
          trailing: SizedBox(
            width: 60,
            child: Row(
              children: [
                InkWell(
                  child: Icon(
                    Icons.edit,
                    color: Colors.black.withOpacity(0.75),
                  ),
                  onTap: () {
                    //
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateWeight(weight: weights[index]),
                        ));
                    //
                  },
                ),
                InkWell(
                  child: const Icon(Icons.delete),

                  onTap: () {
                    //
                    _reference.doc(weights[index].id).delete();
                    // To refresh
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchBar(),
                        ));

                    //
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

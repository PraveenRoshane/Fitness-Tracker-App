// Search Page
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/models/weight_modal.dart';
import 'package:flutter_new/screens/authentication/login_page.dart';
import 'package:flutter_new/screens/home/home.dart';
import 'package:flutter_new/screens/weightTracker/add_weight.dart';
import 'package:flutter_new/screens/weightTracker/home_page.dart';
import 'package:flutter_new/screens/weightTracker/update_weight.dart';


class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  get weights => null;

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();

   // final duplicateItems = List<String>.generate(100, (i) => "Weight $i");

    final CollectionReference _reference =
    FirebaseFirestore.instance.collection('weights');
    final TextEditingController _searchController = TextEditingController();
    final double _drawerIconSize = 24;
    final double _drawerFontSize = 17;
    return Scaffold(
      appBar: AppBar(
        // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    //prefixIcon: const Icon(Icons.search,color: Colors.black,),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.black,),
                      onPressed: () {
                        // Perform the search here
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          )
      ),

      body:FutureBuilder<QuerySnapshot>(
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
                  Icons.monitor_weight_rounded,
                  size: _drawerIconSize,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                ),
                title: Text(
                  'Weight Tracker',
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
                    MaterialPageRoute(builder: (context) => SearchBar()),
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
            : weights[index].weight > 100
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateWeight(weight: weights[index]),
                        ));
                  },
                ),
                InkWell(
                  child: const Icon(Icons.delete),
                  onTap: () {
                    var _reference;
                    _reference.doc(weights[index].id).delete();
                    // To refresh
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchBar(),
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    dummySearchList.addAll(Weight as Iterable<String>);
    if(query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      for (var weight in dummySearchList) {
        if(weight.contains(query)) {
          dummyListData.add(weight);
        }
      }
      setState(() {
        weights.clear();
        weights.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        weights.clear();
        weights.addAll(Weight);
      });
    }
  }
  void setState(Null Function() param0) {}
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_new/screens/diet_tracker/diet_tracker_page.dart';

import 'diet_tracker_page2.dart';

class DietSplashMainScreen extends StatefulWidget {
  const DietSplashMainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DietSplashMainScreenState createState() => _DietSplashMainScreenState();
}

class _DietSplashMainScreenState extends State<DietSplashMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp),
          image: const DecorationImage(
            image: AssetImage("assets/images/tomato.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Center(
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietTrackerPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 33, 243, 198)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
                child: const Text('Monday'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietTrackerPage2()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 33, 243, 198)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
                child: const Text('Tuesday'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietTrackerPage2()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 33, 243, 198)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
                child: const Text('Wednesday'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietTrackerPage2()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 33, 243, 198)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
                child: const Text('Thursday'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietTrackerPage2()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 33, 243, 198)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
                child: const Text('Friday'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietTrackerPage2()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 33, 243, 198)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
                child: const Text('Saturday'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DietTrackerPage2()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 33, 243, 198)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                ),
                child: const Text('Sunday'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

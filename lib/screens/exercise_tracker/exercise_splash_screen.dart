import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_new/screens/exercise_tracker/exercise_tracker_page.dart';

class ExerciseSplashScreen extends StatefulWidget {
  const ExerciseSplashScreen({super.key});

  @override
  _ExerciseSplashScreenState createState() => _ExerciseSplashScreenState();
}

class _ExerciseSplashScreenState extends State<ExerciseSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ExerciseTrackerPage()),
      );
    });
  }

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
        ),
        child: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/exercise.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Exercise Tracker',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 100, right: 100),
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tracking your fitness journey...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

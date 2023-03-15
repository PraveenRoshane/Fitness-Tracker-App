import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new/screens/authentication/login_page.dart';
import 'package:flutter_new/screens/authentication/widgets/header_widget.dart';
import 'package:flutter_new/screens/exercise_tracker/exercise_splash_screen.dart';
import 'package:flutter_new/screens/home/widget/home_card.dart';

import '../progress_tracker/progress_spash_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;
  final double _headerHeight = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ])),
          ),
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings_rounded,
                  size: _drawerIconSize,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: _drawerFontSize,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.help_rounded,
                  size: _drawerIconSize,
                ),
                title: Text(
                  'Help',
                  style: TextStyle(
                    fontSize: _drawerFontSize,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true,
                    Icons.home_rounded), //let's create a common header widget
              ),
              SafeArea(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "What would you like to do today?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 400,
                      child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: [
                            HomeCard(
                              name: "Exercise Tracker",
                              icon: Icons.fitness_center_rounded,
                              press: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ExerciseSplashScreen()));
                              },
                            ),
                            HomeCard(
                              name: "Diet Tracker",
                              icon: Icons.food_bank_rounded,
                              press: () {},
                            ),
                            HomeCard(
                              name: "Weight Tracker",
                              icon: Icons.monitor_weight_rounded,
                              press: () {},
                            ),
                            HomeCard(
                              name: "Progress Tracker",
                              icon: Icons.trending_up_rounded,
                              press: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProgressSplashScreen()));
                              },
                            ),
                          ]),
                    )
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}

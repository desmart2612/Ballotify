import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'voting_page.dart';
import 'login_page.dart';
import 'users.dart';

class HomePage extends StatefulWidget {

  final User usr;

  const HomePage({super.key, required this.usr});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Duration remainingTime = Duration(days: 2, hours: 0, minutes: 0);
  // PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getRemainingTime();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  void _logout() {
    print("Logged out");
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          "Ballotify",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/profile_icon.png'), // Profile picture
            onPressed: () {
              if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                Navigator.of(context).pop();
              } else {
                _scaffoldKey.currentState!.openEndDrawer();
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Days to Election:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatDuration(remainingTime),
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DS-Digital',
                  ),
                ),
                SizedBox(height: 30),
                // PageView for the carousel of steps
                Expanded(
                  child: Transform.translate(
                    offset: const Offset( 0, -25),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CarouselSlider(
                        options: CarouselOptions(height: 500, enlargeCenterPage: true),
                        items: [
                          "Bring your voters ID",
                          "Follow COVID-19 safety guidelines",
                          "Voting closes at 5pm."
                        ].map((guideline) {
                          return Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  guideline, 
                                  style: TextStyle(
                                    fontSize: 18, 
                                    color: Colors.white
                                  ), 
                                  textAlign: TextAlign.center,
                              ),
                              ),
                            ),
                          );
                        }).toList()
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                // Navigate to Voting Page
                Navigator.push(context, MaterialPageRoute(builder: (context) => VotingPage(usr: widget.usr)));
              },
              child: Container(
                width: 65, // Set the width of the FloatingActionButton
                height: 65, // Set the height of the FloatingActionButton
                padding: EdgeInsets.all(10), // Set the padding of the FloatingActionButton
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/ballot_icon.png'), // Ballot icon
                    // fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.usr.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                accountEmail: Text(widget.usr.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_icon.png'),
                  backgroundColor: Colors.green,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 15, 0, 99),
                ),
              ),
              ListTile(
                title: Text("Profile"),
                onTap: () {
                  // Navigate to Profile Page
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Settings"),
                onTap: () {
                  // Navigate to Settings Page
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Logout"),
                // shape: ShapeBorder.lerp(
                //   RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   0.5,
                // ),
                tileColor: Colors.red[900],
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getRemainingTime() async {
    // Your logic to get the remaining time goes here
    String url = "http://192.168.0.101/flutter/API/ballotify_api.php";

    // Use the http package to make a GET request
    http.Response response = await http.post(
      Uri.parse(url),
      body: {
        "purpose": "setTimer",
      }
    );

    if(response.statusCode == 200){
      var launchDate = DateTime.parse(response.body);
      var currentDate = DateTime.now();
      var difference = launchDate.difference(currentDate);
      setState(() {
        remainingTime = difference;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get remaining time'),
          backgroundColor: Colors.red[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

}
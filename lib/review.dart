import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'voting_page.dart';
import 'candidates.dart';
import 'login_page.dart';
import 'users.dart';

class Review extends StatefulWidget {
  final List<Candidate> votes; // Add this line to accept votes
  final User usr;

  const Review({super.key, required this.votes, required this.usr}); // Modify the constructor

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticated = false;
  int otp = 0;

  Future<void> _authenticate() async {
    try {
      bool canAuthenticate = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        _showPINDialog(); // Use PIN fallback if biometrics are unavailable
        return;
      }

      bool authenticated = await _localAuth.authenticate(
        localizedReason: "Authenticate using fingerprint, Face ID, or Windows Hello",
        options: AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (!authenticated) {
        getOtp();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("OTP sent to your registered E-mail. Check your inbox or spam folder."),
            backgroundColor: Colors.blue[900],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        _showPINDialog(); // If biometrics fail, prompt for PIN
      } else {
        setState(() {

          _isAuthenticated = true;
          widget.usr.hasVoted = true;
          castVote();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authentication Successful!")),
        );
      }
    } catch (e) {
      print("Error during authentication: $e");
      getOtp();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP sent to your registered E-mail"),
          backgroundColor: Colors.blue[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      _showPINDialog(); // Use PIN fallback in case of error
    }
  }

  Future<void> _showPINDialog() async {
    TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter PIN"),
          content: TextField(
            controller: pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter your PIN"),
          ),
          actions: [
            TextButton(
              onPressed: () {                                
                if (pinController.text == otp.toString()) { // Hardcoded PIN for demonstration
                  setState(() => _isAuthenticated = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Authentication Successful!")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Incorrect PIN")),
                  );
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void getOtp() async {
    print("OTP sent to your registered E-mail");

    final response = await http.post(
          Uri.parse('http://192.168.0.101/flutter/API/ballotify_api.php'), // Use the correct IP address
          body: {
            'purpose': 'generateOTP',
            'email': widget.usr.email,
          },
        ); // Use the correct IP address
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        otp = int.parse(response.body);
      });
    }
    else {
      print("Failed to get OTP");
    }

  }

  void castVote() async {
    // Send the votes to the server
    http.Response response = await http.post(
      Uri.parse('http://192.168.0.101/flutter/API/ballotify_api.php'), 
      headers: {"Content-Type": "application/json"}, // Set header for JSON
      body: jsonEncode({  // Convert data to JSON string
        'votes': widget.votes.map((vote) => vote.toJson()).toList(), // Convert each vote object to JSON
        'voter': widget.usr.idNumber,
        "purpose": "castVote",
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.push(context, MaterialPageRoute(builder: (context) => VotingPage(usr: widget.usr)));
    } else {
      print("Failed to submit votes");
    }
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,          
          children: [
            Table(
              border: TableBorder.all(color: Colors.black),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Center(child: Text("Candidate",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                    ),
                    TableCell(
                      child: Center(child: Text("Position",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                    ),
                    TableCell(
                      child: Center(child: Text("Party",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                    ),                  
                  ],
                ),
                for (var vote in widget.votes)
                  TableRow(
                    children: [
                      TableCell(
                      child: Center(child: Text(vote.name, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),)),
                      ),
                      TableCell(
                      child: Center(child: Text(vote.position, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),)),
                      ),
                      TableCell(
                      child: Center(child: Text(vote.party, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),)),
                      ),
                    ],
                  ),
              ],
            ),            
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      // Navigate to Voting Page
                      Navigator.push(context, MaterialPageRoute(builder:(context) => VotingPage(usr: widget.usr)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Back to Voting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ),
                  // SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Submit Votes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    )
                ],
              ),
            ),
          ],          
        ),
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
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
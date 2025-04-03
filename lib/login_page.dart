import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';
import 'users.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _handleLogin() async {

    final id = idController.text;
    final password = passwordController.text;

    // Check internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      // No internet connection
      if(id == '41457779' && password == 'd35mart654'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(usr: new User.simplified(name: 'Admin'))));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Admin Login Successful'),
            backgroundColor: Colors.green[900],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection'),
          backgroundColor: Colors.red[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 5),
        ),
      );
      return; // Exit the function if there's no internet
    }
    else{
      try {
        final response = await http.post(
          Uri.parse('http://192.168.0.101/flutter/API/ballotify_api.php'), // Use the correct IP address
          body: {
            'purpose': 'login',
            'id': id,
            'password': password,
          },
        );

        if (response.statusCode == 200 && response.body != 'failure') {
          // print("response recieved");
          final userData = jsonDecode(response.body);          
          final user = User.fromJson(userData);
          print("response transfered");
          user.printData();

          final response2 = await http.post(
            Uri.parse('http://192.168.0.101/flutter/API/ballotify_api.php'),
            body: {
              'purpose': "chckVoteStatus",
              'id': id
            },
          );


          if (response2.statusCode == 200 && response2.body != 'failure') {
            user.hasVoted = true;
            print(response2.body);
          }
        
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(usr: user)));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Successful'),
              backgroundColor: Colors.green[900],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(10),
              duration: Duration(seconds: 5),            
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Failed'),
              backgroundColor: Colors.red[900],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(10),
              duration: Duration(seconds: 5),

            )
          );
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
        
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/welcome_background.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.5 * 255).toInt()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: idController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "ID Number",
                      labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,                        
                      ),
                      filled: true,
                      fillColor: Colors.white38,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.amber, width: 2),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                      floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,                        
                      ),
                      filled: true,
                      fillColor: Colors.white38,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.amber, width: 2),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                        ),
                        onPressed: _handleLogin,
                        child: Text(
                          "Sign In", 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            )
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class CustomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 250);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 250);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

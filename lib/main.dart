import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'package:loading_animations/loading_animations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load resources (precache images and fetch data)
    _loadResources();
  }

  Future<void> _loadResources() async {
    // Fetch data from a mock API
    await _fetchData();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _fetchData() async {
    // Simulate a network call to fetch data
    await Future.delayed(const Duration(seconds: 10)); // Simulate network delay
    // Replace this with actual API calls
    // Example: var data = await http.get(Uri.parse('https://api.example.com/data'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/welcome_background.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          // Content (Logo, Text, Button)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Name
                Text(
                  "BALLOTIFY",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Subtitle
                const SizedBox(height: 5),
                Text(
                  "Online Voting",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                // Loader or Navigation Button
                const SizedBox(height: 80),
                if (_isLoading)
                  // const CircularProgressIndicator(
                  //   valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 60, 170)),
                  // ) 
                  LoadingBouncingGrid.square(
                    backgroundColor: Color.fromARGB(255, 0, 60, 170),
                    size: 40,
                    duration: Duration(seconds: 1),                    
                  ),             
              ],
            ),
          ),
        ],
      ),
    );
  }
}

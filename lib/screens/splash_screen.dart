import 'package:flutter/material.dart';
import 'package:my_task/screens/auth_checker.dart'; // Navigate to AuthChecker

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Wait for 3 seconds

    // Navigate to AuthChecker to check if user is logged in
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthChecker()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_outlined,
              size: 150,
              color: Colors.white,
            ), // Your app logo
            SizedBox(height: 20),
            Text(
              "My Task",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white), // Loading indicator
            SizedBox(height: 10),
            Text(
              "Loading...",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

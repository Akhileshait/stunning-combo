import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile.dart';

void main() {
  runApp(
    MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: LoginScreen(),
        routes: {
          '/userProfile': (context) => UserProfileScreen(),
        }),
  );
}

class LoginScreen extends StatelessWidget {
  final TextEditingController mobileNumberController = TextEditingController();

  Future<void> sendOtpAt(String mobileNumber) async {
    final String apiUrl =
        "http://gbmp.spring.money:3000/auth/otp?mobile_number=$mobileNumber";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Handle success response
        print("OTP sent successfully!");
        print("Response: ${response.body}");
      } else {
        // Handle failure response
        print("Failed to send OTP: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Enter Mobile Number"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final mobileNumber = mobileNumberController.text.trim();
                if (mobileNumber.isNotEmpty) {
                  // Send OTP logic here
                  sendOtp(mobileNumber);

                  // Navigate to WebView for OTP verification
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewApp(
                          mobileNo: mobileNumberController.text.trim()),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid number")),
                  );
                }
              },
              child: Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }

  void sendOtp(String mobileNumber) async {
    await sendOtpAt(mobileNumber);
    print("Sending OTP to $mobileNumber");
  }
}

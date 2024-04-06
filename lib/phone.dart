import 'package:crud/otp.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              Image.network(
  'https://img.freepik.com/free-vector/login-concept-illustration_114360-739.jpg', // Replace with your image URL
  width: 200,
  height: 200,
),

              SizedBox(height: 20.0),
              Text(
                'Enter your phone number',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Checkbox(
                    value: false, // Initially unchecked
                    onChanged: (value) {
                      // Handle checkbox state change
                    },
                  ),
                  Expanded(
                    child: Text(
                      'By Continuing, I agree to TotalX’s Terms and condition & privacy policy',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
             ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OTPPage()),
    );
  },
  child: Text('Get OTP'),
),

            ],
          ),
        ),
      ),
    );
  }
}

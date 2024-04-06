import 'package:crud/home.dart';
import 'package:crud/phone.dart';
import 'package:flutter/material.dart';

class OTPPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to your phone',
              style: TextStyle(fontSize: 18.0),
            ),
               Image.network(
  'https://img.freepik.com/free-vector/login-concept-illustration_114360-739.jpg', // Replace with your image URL
  width: 200,
  height: 200,
),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OTPTextField(),
                OTPTextField(),
                OTPTextField(),
                OTPTextField(),
              ],
            ),
            SizedBox(height: 20.0),
             ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  },
  child: Text('Varify OTP'),
),

          ],
        ),
      ),
    );
  }
}

class OTPTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          counter: Offstage(),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

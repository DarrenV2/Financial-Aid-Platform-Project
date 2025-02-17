import 'package:financial_aid_platform/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "FINANCIAL AID PLATFORM",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: TColors.textBlue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Our goal is to make online education work for everyone",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                  child: Text("SIGN UP"),
                ),
                SizedBox(width: 15),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    side: BorderSide(color: TColors.borderPrimary),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: TColors.textBlue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

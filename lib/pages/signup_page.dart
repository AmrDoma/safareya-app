
import 'package:flutter/material.dart';
import 'package:safareya_app/pages/home_page.dart';
import 'package:safareya_app/pages/login_page.dart';
import 'package:safareya_app/pages/password_field.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Receipt App'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.deepPurple, // Add AppBar title
          foregroundColor: Colors.white),
      body: Center(
        child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Username',
                  floatingLabelStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Enter an username' : null,
              ),
            ),
            PasswordField(name: "Password"),
            PasswordField(name: "Confirm Password"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350, 60),
                backgroundColor:
                    const Color.fromARGB(255, 60, 22, 163), // Brighter color
              ),
              child: const Text('Signup', style: TextStyle(fontSize: 30)),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              },
              child: const Text(
                "Already have an account?",
                style: TextStyle(
                  color: Color.fromARGB(255, 68, 168, 211),
                  fontSize: 16,
                ),
              ),
            ),
            // const SizedBox(height: 40),
            // const Text(
            //   "Forgot Password?",
            //   style: TextStyle(
            //     color: Color.fromARGB(255, 68, 168, 211),
            //     fontSize: 16,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

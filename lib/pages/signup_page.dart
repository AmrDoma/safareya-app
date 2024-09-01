import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safareya_app/pages/login_page.dart';

class SignupPage extends StatefulWidget {
  var _passwordVisible = true;
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firebaseAuth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  var _email = "";

  var _password = "";

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Email',
                    floatingLabelStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onChanged: (value) {
                    _email = value;
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Enter an email' : null,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: TextFormField(
                  obscureText: widget._passwordVisible,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: "Password",
                    floatingLabelStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          widget._passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            widget._passwordVisible = !widget._passwordVisible;
                          });
                        }),
                  ),
                  onChanged: (value) => {
                    _password = value,
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Enter Password' : null,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _firebaseAuth
                        .createUserWithEmailAndPassword(email: _email, password: _password)
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350, 60),
                  backgroundColor:
                      const Color.fromARGB(255, 60, 22, 163), // Brighter color
                ),
                child: const Text('Signup', style: TextStyle(fontSize: 30)),
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}

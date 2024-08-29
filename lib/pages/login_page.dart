
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safareya_app/pages/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safareya_app/pages/signup_page.dart';

class login extends StatefulWidget {
  var _passwordVisible = true;
  login({super.key});

  @override
  State<login> createState() => _loginState();

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print(e);
    }
  }
}
/*
String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }
  */

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();

  var _email = "";

  var _password = "";

  final _firebaseAuth = FirebaseAuth.instance;

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
                  onChanged: (value) => {
                    _email = value,
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _firebaseAuth
                        .signInWithEmailAndPassword(
                            email: _email, password: _password)
                        .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            ))
                        .catchError(
                            (error) => print("Failed to sign in: $error"));
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350, 60),
                  backgroundColor:
                      const Color.fromARGB(255, 60, 22, 163), // Brighter color
                ),
                child: const Text('Signin', style: TextStyle(fontSize: 30)),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () async {
                    widget.signInWithGoogle().then((onValue) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          )
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(350, 60),
                    backgroundColor: const Color.fromARGB(
                        255, 60, 22, 163), // Brighter color
                  ),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(image: AssetImage('assets/googleLogo.png'), height: 20),
                        SizedBox(width: 10),
                        Text('Sigin in with Google',
                            style: TextStyle(fontSize: 29)),
                      ]
                      )
                      ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: const Text(
                  "Don't have an account?",
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

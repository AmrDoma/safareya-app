import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safareya_app/pages/login_page.dart';
import 'view_receipts_page.dart';
import 'create_receipt_page.dart'; // Import the CreateReceiptPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Receipt App'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple, // Add AppBar title
          foregroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: ()  {
              signOutFromGoogle().then((check) {
              if (check)
              {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              }
              }
              );
            },
          ),
          ],),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateReceiptPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 60, 22, 163), // Brighter color
              ),
              child: const Text('Create Receipt'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewReceiptsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 60, 22, 163), // Brighter color
              ),
              child: const Text('View Receipts'),
            ),
          ],
        ),
      ),
    );
  }
}

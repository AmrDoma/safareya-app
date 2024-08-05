import 'package:flutter/material.dart';
import 'view_receipts_page.dart';
import 'create_receipt_page.dart'; // Import the CreateReceiptPage

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Receipt App'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple, // Add AppBar title
          foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateReceiptPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 60, 22, 163), // Brighter color
              ),
              child: Text('Create Receipt'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewReceiptsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 60, 22, 163), // Brighter color
              ),
              child: Text('View Receipts'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // Add this import for date formatting

import 'dart:io'; // Import for File operations
import 'package:flutter/services.dart'
    show rootBundle; // Import for loading assets
import 'package:http/http.dart' as http;
import '../models/receipt.dart'; // Import the Receipt class
import 'receipt_detail_page.dart'; // Import the ReceiptDetailPage

class ViewReceiptsPage extends StatefulWidget {
  @override
  _ViewReceiptsPageState createState() => _ViewReceiptsPageState();
}

class _ViewReceiptsPageState extends State<ViewReceiptsPage> {
  late Future<List<Receipt>> futureReceipts;
  late String backendUrl;
  late int port;

  @override
  void initState() {
    super.initState();
    futureReceipts = Future.value([]); // Initialize with an empty list
    loadConfig().then((_) {
      setState(() {
        futureReceipts = fetchReceipts();
      });
    });
  }

  Future<void> loadConfig() async {
    final String response = await rootBundle.loadString('config.json');
    final config = json.decode(response);
    backendUrl = config['backendUrl'];
    port = config['port'];
  }

  Future<List<Receipt>> fetchReceipts() async {
    final response = await http.get(Uri.parse('$backendUrl/receipts'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (jsonResponse.isEmpty) {
        return [];
      }
      return jsonResponse.map((receipt) => Receipt.fromJson(receipt)).toList();
    } else {
      throw Exception('Failed to load receipts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Receipts'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Receipt>>(
        future: futureReceipts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No receipts found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final receipt = snapshot.data![index];
                final formattedDate =
                    DateFormat('dd-MM-yyyy – hh:mm a').format(receipt.date);

                return ListTile(
                  title: Text('${receipt.title} - $formattedDate'),
                  subtitle: Text(
                    'Total Amount: \$${(receipt.totalAmount.toDouble()).toStringAsFixed(2)}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReceiptDetailPage(receipt: receipt),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

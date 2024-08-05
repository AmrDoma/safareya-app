import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Import for File operations
import 'package:flutter/services.dart'
    show rootBundle; // Import for loading assets

class CreateReceiptPage extends StatefulWidget {
  @override
  _CreateReceiptPageState createState() => _CreateReceiptPageState();
}

class _CreateReceiptPageState extends State<CreateReceiptPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final List<TextEditingController> _itemControllers = [];
  final List<TextEditingController> _amountControllers = [];

  late String backendUrl;
  late int port;

  @override
  void initState() {
    super.initState();
    loadConfig().then((_) {
      print("Config loaded");
      print(backendUrl);
    });
  }

  Future<void> loadConfig() async {
    final String response = await rootBundle.loadString('config.json');
    final config = json.decode(response);
    backendUrl = config['backendUrl'];
    port = config['port'];
  }

  void _addItem() {
    setState(() {
      _itemControllers.add(TextEditingController());
      _amountControllers.add(TextEditingController());
    });
  }

  Future<void> _createReceipt() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final date = DateTime.now().millisecondsSinceEpoch; // Get current timestamp

    final items =
        _itemControllers.map((controller) => controller.text).toList();
    final itemAmounts = _amountControllers
        .map((controller) => double.parse(controller.text))
        .toList();

    final receiptItems = items.asMap().entries.map((entry) {
      int idx = entry.key;
      return {
        'name': entry.value,
        'amount': itemAmounts[idx],
      };
    }).toList();

    //final totalAmount = itemAmounts.reduce((sum, amount) => sum + amount);

    final response = await http.post(
      Uri.parse('$backendUrl/receipts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'description': description,
        'items': receiptItems,
        'date': date,
      }),
    );

// Print response for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receipt created successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to create receipt')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Receipt'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description')),
            ..._itemControllers.map((controller) {
              int index = _itemControllers.indexOf(controller);
              return Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: controller,
                          decoration: InputDecoration(labelText: 'Item Name'))),
                  Expanded(
                      child: TextField(
                          controller: _amountControllers[index],
                          decoration: InputDecoration(labelText: 'Amount'))),
                ],
              );
            }).toList(),
            ElevatedButton(onPressed: _addItem, child: Text('Add Item')),
            ElevatedButton(
                onPressed: _createReceipt, child: Text('Create Receipt')),
          ],
        ),
      ),
    );
  }
}

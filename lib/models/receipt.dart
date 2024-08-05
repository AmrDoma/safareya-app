class Receipt {
  final String id;
  final String title;
  final String description;
  final double totalAmount;
  final List<Item> items;
  final DateTime date;

  Receipt({
    required this.id,
    required this.title,
    required this.description,
    required this.totalAmount,
    required this.items,
    required this.date,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List;
    List<Item> itemList =
        itemsFromJson.map((item) => Item.fromJson(item)).toList();

    return Receipt(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      items: itemList,
      date: DateTime.parse(json['date']),
    );
  }
}

class Item {
  final String name;
  final double amount;

  Item({
    required this.name,
    required this.amount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

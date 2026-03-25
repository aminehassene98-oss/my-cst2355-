import 'package:flutter/material.dart';
import 'app_database.dart';
import 'shopping_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const ShoppingListPage(),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  AppDatabase? database;
  List<ShoppingItem> shoppingList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    database = await $FloorAppDatabase
        .databaseBuilder('shopping_database.db')
        .build();

    final items = await database!.shoppingItemDao.findAllItems();

    setState(() {
      shoppingList = items;
    });
  }

  Future<void> addItem() async {
    final String name = nameController.text.trim();
    final String quantity = quantityController.text.trim();

    if (name.isEmpty || quantity.isEmpty) {
      return;
    }

    final item = ShoppingItem(ShoppingItem.ID++, name, quantity);

    await database!.shoppingItemDao.insertItem(item);

    setState(() {
      shoppingList.add(item);
    });

    nameController.clear();
    quantityController.clear();
  }

  Future<void> deleteItem(ShoppingItem item) async {
    await database!.shoppingItemDao.deleteItem(item);

    setState(() {
      shoppingList.remove(item);
    });
  }

  void confirmDelete(ShoppingItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Do you want to delete "${item.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteItem(item);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addItem,
              child: const Text('Add'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: shoppingList.isEmpty
                  ? const Center(
                child: Text('No items in the shopping list'),
              )
                  : ListView.builder(
                itemCount: shoppingList.length,
                itemBuilder: (context, index) {
                  final item = shoppingList[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      onLongPress: () {
                        confirmDelete(item);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
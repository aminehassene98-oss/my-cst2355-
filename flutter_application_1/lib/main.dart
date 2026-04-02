import 'package:flutter/material.dart';
import 'app_database.dart';
import 'shopping_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Week 9 Shopping List',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Text controllers for the input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  // This stores all shopping items from the database
  List<ShoppingItem> itemList = [];

  // This stores the selected item for the details page
  ShoppingItem? selectedItem;

  // Floor database object
  late AppDatabase database;

  @override
  void initState() {
    super.initState();
    loadDatabase();
  }

  // Build the database and load all items
  Future<void> loadDatabase() async {
    database = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .build();

    final items = await database.shoppingItemDao.findAllItems();

    setState(() {
      itemList = items;
    });
  }

  // Add a new item to the database and refresh the list
  Future<void> addItem() async {
    String name = nameController.text.trim();
    String quantity = quantityController.text.trim();

    if (name.isEmpty || quantity.isEmpty) {
      return;
    }

    final newItem = ShoppingItem(ShoppingItem.ID, name, quantity);

    await database.shoppingItemDao.insertItem(newItem);

    final updatedItems = await database.shoppingItemDao.findAllItems();

    setState(() {
      itemList = updatedItems;
      nameController.clear();
      quantityController.clear();
    });
  }

  // Delete the selected item from database and refresh the list
  Future<void> deleteSelectedItem() async {
    if (selectedItem != null) {
      await database.shoppingItemDao.deleteItem(selectedItem!);

      final updatedItems = await database.shoppingItemDao.findAllItems();

      setState(() {
        itemList = updatedItems;
        selectedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List Week 9'),
      ),
      body: Column(
        children: [
          // Input section
          Padding(
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
                  child: const Text('Add Item'),
                ),
              ],
            ),
          ),

          // Responsive layout section
          Expanded(
            child: reactiveLayout(width, height),
          ),
        ],
      ),
    );
  }

  // This function changes the layout depending on screen size
  Widget reactiveLayout(double width, double height) {
    // Tablet / desktop / wide landscape mode:
    // show list on the left and details on the right
    if ((width > height) && (width > 720)) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: listPage(),
          ),
          Expanded(
            flex: 2,
            child: detailsPage(),
          ),
        ],
      );
    }

    // Phone / portrait mode:
    // show either list page or details page
    else {
      if (selectedItem == null) {
        return listPage();
      } else {
        return detailsPage();
      }
    }
  }

  // This function shows the shopping list
  Widget listPage() {
    if (itemList.isEmpty) {
      return const Center(
        child: Text('No items in the list'),
      );
    }

    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final item = itemList[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(item.name),
            subtitle: Text('Quantity: ${item.quantity}'),

            // Week 9 requirement:
            // change long press to tap
            onTap: () {
              setState(() {
                selectedItem = item;
              });
            },
          ),
        );
      },
    );
  }

  // This function shows the details of the selected item
  Widget detailsPage() {
    if (selectedItem == null) {
      return const Center(
        child: Text('No item selected'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Show item name
          Text(
            'Name: ${selectedItem!.name}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),

          // Show item quantity
          Text(
            'Quantity: ${selectedItem!.quantity}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),

          // Show item database ID
          Text(
            'ID: ${selectedItem!.id}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              // Delete button
              ElevatedButton(
                onPressed: () async {
                  await deleteSelectedItem();
                },
                child: const Text('Delete'),
              ),
              const SizedBox(width: 10),

              // Close button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedItem = null;
                  });
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
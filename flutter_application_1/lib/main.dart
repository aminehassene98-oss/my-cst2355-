import 'package:flutter/material.dart';

// The data model for our shopping items
class ShoppingItem {
  String name;
  String quantity;
  ShoppingItem(this.name, this.quantity);
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyShoppingApp(),
  ));
}

class MyShoppingApp extends StatefulWidget {
  @override
  State<MyShoppingApp> createState() => _MyShoppingAppState();
}

class _MyShoppingAppState extends State<MyShoppingApp> {
  // My list to hold the shopping data
  List<ShoppingItem> myItems = [];
  // Controllers to get the text from the input boxes
  final nameController = TextEditingController();
  final qtyController = TextEditingController();
// This function adds the item to the list and refreshes the UI
  void addNewItem() {
    if (nameController.text.isNotEmpty && qtyController.text.isNotEmpty) {
      setState(() {
        // Create new item and add it to the list
        myItems.add(ShoppingItem(nameController.text, qtyController.text));
        // Clear the boxes after adding so they are empty for the next one
        nameController.clear();
        qtyController.clear();
      });
    }
  }
// This function shows the "Yes/No" delete box
  void deleteItemDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Item?"),
        content: Text("Remove ${myItems[index].name}?"),
        actions: [
          // No button: just closes the pop-up
          TextButton(onPressed: () => Navigator.pop(context), child: Text("No")),
          TextButton(
            onPressed: () {
              setState(() => myItems.removeAt(index));
              Navigator.pop(context);//this closes the box
            },
            // Yes button: deletes the item and updates the screen
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  // layout in your image
  Widget ListPage() {
    return Column(
      children: [
        // Top section for typing in items
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Type the item here",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: qtyController,
                  decoration: InputDecoration(
                    hintText: "Type the quantity here",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: addNewItem,
                child: Text("Click here"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.withOpacity(0.1),
                  foregroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),

        // Bottom section for showing the list
        Expanded(
          child: myItems.isEmpty
              ? Center(child: Text("There are no items in the list"))
              : ListView.builder(
            itemCount: myItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () => deleteItemDialog(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    "${index + 1}: ${myItems[index].name}  quantity: ${myItems[index].quantity}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo Home Page"),
        backgroundColor: Colors.purple.shade100,
        centerTitle: true,
      ),
      body: ListPage(),
    );
  }
}
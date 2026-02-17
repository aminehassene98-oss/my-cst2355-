import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3 Recipe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Recipe Index'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text("BROWSE CATEGORIES",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Not sure about exactly which recipe you're looking for? Do a search, or dive into our most popular categories.")
            ),
          ),
          const Center(
              child: Text("BY MEAT", style: TextStyle(fontWeight: FontWeight.bold))
          ),

          // ⬇️ FIRST ROW - uses buildFoodItemWithOverlay (text ON image)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildFoodItemWithOverlay("BEEF", "images/beef.jpg"),
              buildFoodItemWithOverlay("CHICKEN", "images/chicken.jpg"),
              buildFoodItemWithOverlay("PORK", "images/pork.jpg"),
              buildFoodItemWithOverlay("SEAFOOD", "images/seafood.jpg"),
            ],
          ),

          const Center(
              child: Text("BY COURSE", style: TextStyle(fontWeight: FontWeight.bold))
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildFoodItem("Main Dishes", "images/main_dish.jpg"),
              buildFoodItem("Salad", "images/salad.jpg"),
              buildFoodItem("Sides", "images/side_dish.jpg"),
              buildFoodItem("Crockpot", "images/crockpot.jpg"),
            ],
          ),

          const Center(
              child: Text("BY DESSERT", style: TextStyle(fontWeight: FontWeight.bold))
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildFoodItem("Ice Cream", "images/ice_cream.png"),
              buildFoodItem("Brownie", "images/brownie.png"),
              buildFoodItem("Pies", "images/pie.png"),
              buildFoodItem("Cookies", "images/cookie.png"),
            ],
          ),
        ],
      ),
    );
  }


  Widget buildFoodItemWithOverlay(String label, String imagePath) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 38,
          backgroundImage: AssetImage(imagePath),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black54,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //  for other rows (text BELOW the image)
  Widget buildFoodItem(String label, String imagePath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundImage: AssetImage(imagePath),
        ),
        Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
        ),
      ],
    );
  }
}
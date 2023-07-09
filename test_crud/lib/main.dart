import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/quality_form.dart';

// Define a model class for the data

void main() async {
  // Initialize hive and open a box
  await Hive.initFlutter();
  var box = await Hive.openBox('items');

  // Run the app
  runApp(MyApp(box: box));
}

class MyApp extends StatelessWidget {
  // The box to store the data
  final Box box;

  const MyApp({Key? key, required this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(box: box),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // The box to store the data
  final Box box;

  const MyHomePage({Key? key, required this.box}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // The list of items
  List<Item> items = [];
  @override
  void initState() {
    super.initState();
    // Load the items from the box
    loadItems();
  }

  // Load the items from the box
  void loadItems() {
    setState(() {
      items = widget.box.values
          .map((e) => Item.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  void updateItems() {
    setState(() {
      items = widget.box.values
          .map((e) => Item.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  // Delete an item from the box and the list
  void deleteItem(int index) {
    widget.box.deleteAt(index);
    setState(() {
      items.removeAt(index);
    });
  }

  // Show a bottom sheet to add or edit an item
  void showBottomSheet(BuildContext context, {int? index}) {
    // If index is not null, it means we are editing an existing item
    bool isEditing = index != null;

    Item? item = isEditing ? items[index!] : null;
    // Set the initial values of the input fields

    // Show the bottom sheet
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return FormWidget(
              box: widget.box, item: item, index: index, onUpdate: updateItems);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Flutter CRUD App'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          // Get the item at the index
          var item = items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // Show the bottom sheet to edit the item
                    showBottomSheet(context, index: index);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    // Delete the item
                    deleteItem(index);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the bottom sheet to add a new item
          showBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

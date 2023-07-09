import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/quality_form.dart';

// Define a model class for the data
class Item {
  final String name;
  final int quantity;

  Item(this.name, this.quantity);

  // Convert an item to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }

  // Convert a map to an item
  Item.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        quantity = map['quantity'];
}

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

  // The controller for the name input field
  TextEditingController nameController = TextEditingController();

  // The controller for the quantity input field
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load the items from the box
    loadItems();
  }

  // Load the items from the box
  void loadItems() {
    setState(() {
      items = widget.box.values.map((e) => Item.fromMap(e)).toList();
    });
  }

  // Add a new item to the box and the list
  void addItem(String name, int quantity) {
    var item = Item(name, quantity);
    widget.box.add(item.toMap());
    setState(() {
      items.add(item);
    });
  }

  // Update an existing item in the box and the list
  void updateItem(int index, String name, int quantity) {
    var item = Item(name, quantity);
    widget.box.putAt(index, item.toMap());
    setState(() {
      items[index] = item;
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

    var item = isEditing ? items[index!] : null;
    // Set the initial values of the input fields
    nameController.text = isEditing ? items[index!].name : '';
    quantityController.text =
        isEditing ? items[index!].quantity.toString() : '';

    // Show the bottom sheet
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return FormWidget(box: widget.box, item: item, index: index);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Flutter CRUD App'),
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
                  icon: Icon(Icons.edit),
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
        child: Icon(Icons.add),
      ),
    );
  }
}

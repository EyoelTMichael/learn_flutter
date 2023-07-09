// Create a file called form_widget.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

// Define a widget for the form
class FormWidget extends StatefulWidget {
  // The box to store the data
  final Box box;

  // The optional parameter for the form data
  final Item? item;

  // The index of the item in the box, if editing
  final int? index;

  final VoidCallback onUpdate;

  const FormWidget(
      {Key? key,
      required this.box,
      this.item,
      this.index,
      required this.onUpdate})
      : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  // The controller for the name input field
  TextEditingController nameController = TextEditingController();

  // The controller for the quantity input field
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If the item parameter is not null, set the initial values of the input fields
    if (widget.item != null) {
      nameController.text = widget.item!.name;
      quantityController.text = widget.item!.quantity.toString();
    }
  }

  // Add a new item to the box
  void addItem(String name, int quantity) {
    var item = Item(name, quantity);
    widget.box.add(item.toMap());
    Navigator.pop(context);
    widget.onUpdate();
  }

  // Update an existing item in the box
  void updateItem(int index, String name, int quantity) {
    var item = Item(name, quantity);
    widget.box.putAt(index, item.toMap());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.item == null ? 'Add Item' : 'Edit Item',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 8),
          TextField(
            controller: quantityController,
            decoration: InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Validate the input fields
              if (nameController.text.isEmpty ||
                  quantityController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter a name and a quantity')));
                return;
              }

              // Parse the quantity as an integer
              int quantity = int.tryParse(quantityController.text) ?? 0;

              // Add or update the item
              if (widget.item == null) {
                addItem(nameController.text, quantity);
              } else {
                updateItem(widget.index!, nameController.text, quantity);
              }
            },
            child: Text(widget.item == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }
}

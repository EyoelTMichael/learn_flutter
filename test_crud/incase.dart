// ListView.builder(
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           // Get the item at the index
//           var item = items[index];
//           return ListTile(
//             title: Text(item.name),
//             subtitle: Text('Quantity: ${item.quantity}'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     // Show the bottom sheet to edit the item
//                     showBottomSheet(context, index: index);
//                   },
//                   icon: Icon(Icons.edit),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     // Delete the item
//                     deleteItem(index);
//                   },
//                   icon: Icon(Icons.delete),
//                 ),
//               ],
//             ),
//           );
//         },
//       )
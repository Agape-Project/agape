//  return ConstrainedBox(
//       constraints: const BoxConstraints(maxWidth: 450),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Records"),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView (
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Search here',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(24),
//                             borderSide: const BorderSide(color: primaryColor),
//                           ),
//                           prefixIcon: const Icon(Icons.search),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.filter_alt_outlined),
//                       onPressed: () {
//                         _showFilterPopup(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               // List of user cards
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: 10, // Example count, replace with dynamic data count
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0, vertical: 4.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => UserDetailsPage(),
//                           ),
//                         );
//                       },
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Row(
//                             children: [
//                               // User image
//                               CircleAvatar(
//                                 radius: 30,
//                                 backgroundColor: Colors.grey[300],
//                                 child: Icon(Icons.person,
//                                     size: 30, color: Colors.grey[700]),
//                               ),
//                               const SizedBox(width: 12),
//                               // User details
//                               const Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Abebe Abebe Abebe',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       'Gender: Male', // Example, replace dynamically
//                                       style: TextStyle(color: Colors.grey),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // Status indicator
//                               Text(
//                                 index % 2 == 0 ? 'Pending' : 'Completed',
//                                 style: TextStyle(
//                                   color: index % 2 == 0
//                                       ? Colors.orange
//                                       : Colors.green,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               // Pagination buttons
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Implement previous page logic
//                       },
//                       child: const Text('Back'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Implement next page logic
//                       },
//                       child: const Text('Next'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showFilterPopup(BuildContext context) {
//   String? selectedGender;
//   String? selectedRegion;
//   String? selectedSize;
//   String? selectedMonth;
//   String? selectedEquipmentType;
//   int? selectedYear;


//   final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];


//   showDialog(
//     context: context,
//     builder: (context) => StatefulBuilder(
//       builder: (context, setState) {
//         return AlertDialog(
//           title: const Text('Filter Options'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Gender Filter
               
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     prefixIcon: Icon(Icons.person_outline),
//                     labelText: 'Gender',
//                   ),
//                   items: ['Male', 'Female']
//                       .map((label) => DropdownMenuItem(
//                             value: label,
//                             child: Text(label),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedGender = value;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please select a gender';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),

//                 // Region Filter
               
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     prefixIcon: Icon(Icons.person_outline),
//                     labelText: 'Region',
//                   ),
//                   items: ['Addis Ababa', 'Oromia','Tigray','Afar','Amhara','Benishangul-Gumuz','Central Ethiopia','Dire Dawa','Gambela','Harari','Sidama','Somali','South Ethiopia',]
//                       .map((label) => DropdownMenuItem(
//                             value: label,
//                             child: Text(label),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedRegion = value;
//                     });
//                   },
//                   validator: (value) {
//                     // if (value == null) {
//                     //   return 'Please select a gender';
//                     // }
//                     // return null;
//                   },
//                    menuMaxHeight: 200,
//                 ),
//                 const SizedBox(height: 10),

//                 // Size Filter
             
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     prefixIcon: Icon(Icons.person_outline),
//                     labelText: 'Size',
//                   ),
//                   items: ['Small', 'Medium','Large','XL']
//                       .map((label) => DropdownMenuItem(
//                             value: label,
//                             child: Text(label),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedSize = value;
//                     });
//                   },
//                   menuMaxHeight: 200,
//                 ),
//                 const SizedBox(height: 10),

//                 // Month Filter
               
//                 DropdownButtonFormField<String>(
//                    decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     prefixIcon: Icon(Icons.person_outline),
//                     labelText: 'Month',
//                   ),
//                   value: selectedMonth,
//                   isExpanded: true,
//                   hint: const Text('Select Month'),
//                   items: months.map((month) {
//                     return DropdownMenuItem(
//                       value: month,
//                       child: Text(month),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedMonth = value;
//                     });
//                   },
//                    menuMaxHeight: 200,
//                 ),
//                 const SizedBox(height: 10),

//                 // Year Filter
               
//                 ElevatedButton(
//   style: ElevatedButton.styleFrom(
//     foregroundColor: Colors.black,
    
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8), 
//       side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)), 
//     ),
//     elevation: 0, 
//   ),
//   onPressed: () async {
//     final currentYear = DateTime.now().year;
//     final year = await showDatePicker(
//       context: context,
//       initialDate: DateTime(currentYear),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(currentYear + 10),
//       builder: (context, child) {
//         return child!;
//       },
//     );
//     if (year != null) {
//       setState(() {
//         selectedYear = year.year;
//       });
//     }
//   },
//   child: Text(
//     selectedYear != null ? selectedYear.toString() : 'Select Year',
//     style: const TextStyle(color: Colors.black), 
//   ),
// ),

//                 const SizedBox(height: 10),

//                 // Equipment Type Filter
                
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     prefixIcon: Icon(Icons.person_outline),
//                     labelText: 'Equipment Type',
//                   ),
//                   items: ['Pediatric Wheelchair', 'American Wheelchair','(FWP) Wheelchair','Walker','Crutches','Cane',]
//                       .map((label) => DropdownMenuItem(
//                             value: label,
//                             child: Text(label),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedEquipmentType = value;
//                     });
//                   },
//                   validator: (value) {
//                     // if (value == null) {
//                     //   return 'Please select a gender';
//                     // }
//                     // return null;
//                   },
//                    menuMaxHeight: 200,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Apply filter logic
//                 Navigator.pop(context);
//               },
//               child: const Text('Apply'),
//             ),
//           ],
//         );
//       },
//     ),
//   );
// }

// }

// class UserDetailsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Details'),
//       ),
//       body: const Center(
//         child: Text('User details page content'),
//       ),
//     );
//   }
// }
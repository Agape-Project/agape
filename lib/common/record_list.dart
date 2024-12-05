import 'package:agape/common/controllers/record_controller.dart';
import 'package:agape/common/record_details.dart';
import 'package:agape/utils/colors.dart';
import 'package:agape/widgets/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  late Future<List<Map<String, dynamic>>> _userRecords;

  @override
  void initState() {
    super.initState();
    _fetchUserRecords();
  }

  void _fetchUserRecords() {
    final recordController = ref.read(disabilityRecordControllerProvider);
    _userRecords = recordController.getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _userRecords,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LoadingIndicatorWidget());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No records found.'));
                } else {
                  final records = snapshot.data!;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search here',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide:
                                        const BorderSide(color: primaryColor),
                                  ),
                                  prefixIcon: const Icon(Icons.search),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.filter_alt_outlined),
                              onPressed: () {
                                _showFilterPopup(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final record = records[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecordDetailsPage(record: record),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            record['profile_image_url'] ??
                                                'https://via.placeholder.com/150',
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                " ${record['first_name']} ${record['middle_name']}" ??
                                                    'Unknown',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Gender: ${record['gender'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          record['is_provided']
                                              ? 'Completed'
                                              : 'Pending',
                                          style: TextStyle(
                                            color: (record['is_provided'] ==
                                                    'Completed')
                                                ? Colors.green
                                                : Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterPopup(BuildContext context) {
  String? selectedGender;
  String? selectedRegion;
  String? selectedSize;
  String? selectedMonth;
  String? selectedEquipmentType;
  int? selectedYear;


  final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];


  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gender Filter
               
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Gender',
                  ),
                  items: ['Male', 'Female']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Region Filter
               
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Region',
                  ),
                  items: ['Addis Ababa', 'Oromia','Tigray','Afar','Amhara','Benishangul-Gumuz','Central Ethiopia','Dire Dawa','Gambela','Harari','Sidama','Somali','South Ethiopia',]
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value;
                    });
                  },
                  validator: (value) {
                    // if (value == null) {
                    //   return 'Please select a gender';
                    // }
                    // return null;
                  },
                   menuMaxHeight: 200,
                ),
                const SizedBox(height: 10),

                // Size Filter
             
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Size',
                  ),
                  items: ['Small', 'Medium','Large','XL']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSize = value;
                    });
                  },
                  menuMaxHeight: 200,
                ),
                const SizedBox(height: 10),

                // Month Filter
               
                DropdownButtonFormField<String>(
                   decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Month',
                  ),
                  value: selectedMonth,
                  isExpanded: true,
                  hint: const Text('Select Month'),
                  items: months.map((month) {
                    return DropdownMenuItem(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value;
                    });
                  },
                   menuMaxHeight: 200,
                ),
                const SizedBox(height: 10),

                // Year Filter
               
                ElevatedButton(
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), 
      side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)), 
    ),
    elevation: 0, 
  ),
  onPressed: () async {
    final currentYear = DateTime.now().year;
    final year = await showDatePicker(
      context: context,
      initialDate: DateTime(currentYear),
      firstDate: DateTime(2000),
      lastDate: DateTime(currentYear + 10),
      builder: (context, child) {
        return child!;
      },
    );
    if (year != null) {
      setState(() {
        selectedYear = year.year;
      });
    }
  },
  child: Text(
    selectedYear != null ? selectedYear.toString() : 'Select Year',
    style: const TextStyle(color: Colors.black), 
  ),
),

                const SizedBox(height: 10),

                // Equipment Type Filter
                
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Equipment Type',
                  ),
                  items: ['Pediatric Wheelchair', 'American Wheelchair','(FWP) Wheelchair','Walker','Crutches','Cane',]
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedEquipmentType = value;
                    });
                  },
                  validator: (value) {
                    // if (value == null) {
                    //   return 'Please select a gender';
                    // }
                    // return null;
                  },
                   menuMaxHeight: 200,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Apply filter logic
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}
}

class UserDetailsPage extends StatelessWidget {
  final Map<String, dynamic> record;

  const UserDetailsPage({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record['name'] ?? 'Unknown',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Gender: ${record['gender'] ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Status: ${record['is_provided'] ? 'Completed' : 'Pending'}'),
          ],
        ),
      ),
    );
  }
}

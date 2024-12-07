import 'package:flutter/material.dart';

class ExportPage extends StatefulWidget {
  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  // Simulated large dataset (can be replaced with database fetch)
  final List<Map<String, dynamic>> allData = List.generate(1000, (index) {
    return {
      'First': 'First $index',
      'Middle': 'Middle $index',
      'Last': 'Last $index',
      'Age': 20 + (index % 30),
      'Gender': index % 2 == 0 ? 'Male' : 'Female',
      'Region': 'Region ${index % 5}',
      'Zone': 'Zone ${index % 10}',
      'City': 'City ${index % 20}',
      'Woreda': 'Woreda ${index % 15}',
      'Equipment Type': 'Type ${index % 3}',
      'Size': index % 3 == 0 ? 'Large' : 'Medium',
      'Registration Date': '2024-01-${(index % 30) + 1}',
    };
  });

  int currentPage = 0;
  final int rowsPerPage = 30;

  // Map to track selected headers
  Map<String, bool> selectedHeaders = {};
  List<Map<String, dynamic>> filteredData = [];
  String selectedFilter = 'None';

  @override
  void initState() {
    super.initState();
    filteredData = allData; // Start with all data
  }

  void applyFilter(String filterOption) {
    setState(() {
      if (filterOption == 'None') {
        filteredData = allData;
      } else {
        filteredData = allData.where((row) {
          return row['Region'] == filterOption;
        }).toList();
      }
      currentPage = 0; // Reset to first page
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedData = filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("File Export Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: allData.first.keys.map((key) {
                    return DataColumn(
                      label: Row(
                        children: [
                          Checkbox(
                            value: selectedHeaders[key] ?? false,
                            onChanged: (value) {
                              setState(() {
                                selectedHeaders[key] = value ?? false;
                              });
                            },
                          ),
                          Container(
                            color: (selectedHeaders[key] ?? false)
                                ? Colors.green
                                : Colors.transparent,
                            child: Text(
                              key,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  rows: displayedData.map((dataRow) {
                    return DataRow(
                      cells: dataRow.values.map((value) {
                        return DataCell(Text(value.toString()));
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentPage > 0)
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentPage--;
                    });
                  },
                  child: Text("Back"),
                ),
              if ((currentPage + 1) * rowsPerPage < filteredData.length)
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentPage++;
                    });
                  },
                  child: Text("Next"),
                ),
            ],
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showExportOptions(context);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.download),
                      SizedBox(width: 8),
                      Text("Export"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Filter"),
          content: DropdownButton<String>(
            value: selectedFilter,
            items: ['None', 'Region 0', 'Region 1', 'Region 2', 'Region 3', 'Region 4']
                .map((filter) => DropdownMenuItem(
                      value: filter,
                      child: Text(filter),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                applyFilter(value);
                setState(() {
                  selectedFilter = value;
                });
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Export as CSV"),
                onTap: () {
                  _exportData("CSV");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Export as Excel"),
                onTap: () {
                  _exportData("Excel");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _exportData(String fileType) {
    final selectedColumns = selectedHeaders.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Simulate a backend call
    Future.delayed(Duration(seconds: 2), () {
      if (selectedColumns.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No columns selected for export.")),
        );
        return;
      }

      // Send selectedColumns and fileType to backend
      print("Exporting as $fileType with columns: $selectedColumns");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data exported as $fileType successfully!")),
      );
    });
  }
}

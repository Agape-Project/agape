// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:agape/common/controllers/record_controller.dart';
import 'package:agape/common/screens/register_record.dart';
import 'package:agape/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agape/widgets/snackbar.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class RecordDetailsPage extends ConsumerWidget {
  final String recordId;
  const RecordDetailsPage({
    Key? key,
    required this.recordId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<Map<String, dynamic>> fetchRecord() async {
      return await ref
          .read(disabilityRecordControllerProvider)
          .getRecordById(recordId);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Record Details'),
          centerTitle: true,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: fetchRecord(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No data found.'),
                );
              } else {
                final record = snapshot.data!;
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Profile Container
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Avatar Section
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ImageOverlay(
                                        imageUrl: record['profile_image'] ?? '',
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: record['profile_image'] !=
                                            null
                                        ? NetworkImage(record['profile_image'])
                                        : const NetworkImage(
                                            'https://via.placeholder.com/150'),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Details Section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: DetailRow(
                                          title: 'First Name',
                                          value: record['first_name'] ?? ''),
                                    ),
                                    DetailRow(
                                        title: 'Middle Name',
                                        value: record['middle_name'] ?? ''),
                                    DetailRow(
                                        title: 'Last Name',
                                        value: record['last_name'] ?? ''),
                                    DetailRow(
                                        title: 'Gender',
                                        value: record['gender'] ?? ''),
                                    DetailRow(
                                      title: 'Age',
                                      value: calculateAge(
                                              record['date_of_birth'] ?? '')
                                          .toString(),
                                    ),
                                    DetailRow(
                                        title: 'Region',
                                        value: record['region'] ?? ''),
                                    DetailRow(
                                        title: 'Zone',
                                        value: record['zone'] ?? ''),
                                    DetailRow(
                                        title: 'Woreda',
                                        value: record['woreda'] ?? ''),
                                    DetailRow(
                                        title: 'Hip Width',
                                        value:
                                            "${record['hip_width'] ?? ''} cm"),
                                    DetailRow(
                                        title: 'Backrest Height',
                                        value:
                                            "${record['backrest_height'] ?? ''} cm"),
                                    DetailRow(
                                        title: 'Thigh Length',
                                        value:
                                            "${record['thigh_length'] ?? ''} cm"),
                                    DetailRow(
                                        title: 'Equipment Type',
                                        value: record['equipment']
                                                ?['equipment_type'] ??
                                            ''),
                                    DetailRow(
                                        title: 'Cause of need',
                                        value: record['equipment']
                                                ?['cause_of_need'] ??
                                            ''),
                                    DetailRow(
                                        title: 'Equipment Size',
                                        value:
                                            "${record['equipment']?['size'] ?? ''}"),
                                    DetailRow(
                                        title: 'Registration Date',
                                        value:
                                            formatDate(record['created_at'])),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // ID Card Section
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ImageOverlay(
                                        imageUrl:
                                            record['kebele_id_image'] ?? '',
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: record['kebele_id_image'] != null
                                            ? NetworkImage(
                                                record['kebele_id_image'])
                                            : const NetworkImage(
                                                'https://via.placeholder.com/150'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),
                                // Warranty Dropdown
                                WarrantyDropdown(
                                    warrant: record['warrant'] ?? {}),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterRecord(
                                        recordId: record['id'],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Edit'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final response = await ref
                                      .read(disabilityRecordControllerProvider)
                                      .deleteRecord(recordId);

                                  showCustomSnackBar(context,
                                      title: 'Success',
                                      message: response,
                                      type: AnimatedSnackBarType.success);

                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageOverlay extends StatelessWidget {
  final String imageUrl;

  const ImageOverlay({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 400,
          ),
          child: Stack(
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              Positioned(
                bottom: 16,
                right: 16,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Implement download functionality
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WarrantyDropdown extends StatefulWidget {
  final Map<String, dynamic> warrant;

  const WarrantyDropdown({required this.warrant});

  @override
  _WarrantyDropdownState createState() => _WarrantyDropdownState();
}

class _WarrantyDropdownState extends State<WarrantyDropdown> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Warranty Information'),
                Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DetailRow(
                    title: 'First Name',
                    value: widget.warrant['first_name'] ?? ''),
                DetailRow(
                    title: 'Middle Name',
                    value: widget.warrant['middle_name'] ?? ''),
                DetailRow(
                    title: 'Last Name',
                    value: widget.warrant['last_name'] ?? ''),
                DetailRow(
                    title: 'Gender', value: widget.warrant['gender'] ?? ''),
                DetailRow(
                    title: 'Phone Number',
                    value: widget.warrant['phone_number'] ?? ''),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ImageOverlay(
                        imageUrl: widget.warrant['id_image'] ?? '',
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(widget.warrant['id_image'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

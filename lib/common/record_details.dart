import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecordDetailsPage extends StatelessWidget {
  const RecordDetailsPage({super.key, required Map<String, dynamic> record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
      ),
      body: Center(
      
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
                  child: Stack(
                    children: [
                     // Add "Completed" text
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    
                     Column(
                      children: [
                        // Avatar Section
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const ImageOverlay(
                                imageUrl: 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png',
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Details Section
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child:DetailRow(title: 'First Name', value: 'Abebe'),),
                            DetailRow(title: 'Middle Name', value: 'Abebe'),
                            DetailRow(title: 'Last Name', value: 'Abebe'),
                            DetailRow(title: 'Gender', value: 'Male'),
                            DetailRow(title: 'Age', value: '15',),
                            DetailRow(title: 'Phone number', value: '0912365458',),
                            DetailRow(title: 'Region', value: 'Amhara'),
                            DetailRow(title: 'Zone', value: 'North Gondar'),
                            DetailRow(title: 'Woreda', value: '2'),
                            DetailRow(title: 'Hip Width', value: '15.7 cm'),
                            DetailRow(title: 'Backrest Height', value: '15.2 cm'),
                            DetailRow(title: 'Thigh Length', value: '17.5 cm'),
                            DetailRow(title: 'Equipment Type', value: 'pediatric wheelchair'),
                            DetailRow(title: 'Cause of need', value: 'Polio'),
                            DetailRow(title: 'Equipment Size', value: 'XL'),
                            DetailRow(title: 'Registration Date', value: '18/8/2024'),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // ID Card Section
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const ImageOverlay(
                                imageUrl: 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png',
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: NetworkImage('https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Warranty Dropdown
                        const WarrantyDropdown(),
                      ],
                    ),],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
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
      ),
    );
  }
}

// Making phone numbers clickable
class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final isPhoneNumber = title.toLowerCase().contains("phone");

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
            child: GestureDetector(
              onTap: isPhoneNumber
                  ? () async {
                      final uri = Uri(scheme: "tel", path: value);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot launch phone dialer.'),
                          ),
                        );
                      }
                    }
                  : null,
              child: Text(
                value,
                style: TextStyle(
                  color: isPhoneNumber ? Colors.blue : Colors.black,
                  decoration:
                      isPhoneNumber ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
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
  const WarrantyDropdown({super.key});

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
                const DetailRow(title: 'First Name', value: 'Abebe'),
                const DetailRow(title: 'Middle Name', value: 'Abebe'),
                const DetailRow(title: 'Last Name', value: 'Abebe'),
                const DetailRow(title: 'Gender', value: 'Male'),
                const DetailRow(title: 'Phone Number', value: '0900000000'),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ImageOverlay(
                        imageUrl: 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png',
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: NetworkImage('https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_640.png'),
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

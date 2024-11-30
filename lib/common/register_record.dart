import 'dart:io';

import 'package:agape/auth/screens/a.dart';
import 'package:agape/widgets/CustomTextFormField.dart';
import 'package:agape/widgets/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomStepper extends StatefulWidget {
  const CustomStepper({Key? key}) : super(key: key);

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int _currentStep = 0;
    final _formKey1 = GlobalKey<FormState>();  
  final _formKey2 = GlobalKey<FormState>(); 
    final _formKey3 = GlobalKey<FormState>(); 
     final _formKey4 = GlobalKey<FormState>(); 
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _woredaController = TextEditingController();
  final _hipWidthController = TextEditingController();
  final _backrestHeightController = TextEditingController();
  final _thighLengthController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _selectedGender;
   String? _selectedRegion; 
  String? _selectedEquipmentType;
  String? _selectedCause;
  String? _selectedSize;
  String? _customCause;
  File? _photoFile;
  File? _idCardFile;
 double _photoUploadProgress = 0.0;
double _idCardUploadProgress = 0.0;
  bool isProvided = false;
//methods
Future<void> _pickImage(bool isPhoto) async {
  try {
    // Use the `image_picker` package to pick or capture an image
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera, // Opens the camera for capturing an image
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      // Convert the picked file to a `File` object
      File imageFile = File(pickedFile.path);

      // Simulate an upload process
      await _simulateUpload(isPhoto);

      setState(() {
        if (isPhoto) {
          _photoFile = imageFile;
        } else {
          _idCardFile = imageFile;
        }
      });
    }
  } catch (e) {
    print("Error picking image: $e");
  }
} 
Future<void> _simulateUpload(bool isPhoto) async {
  double progress = 0.0;
  while (progress < 1.0) {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      progress += 0.1;
      if (isPhoto) {
        _photoUploadProgress = progress;
      } else {
        _idCardUploadProgress = progress;
      }
    });
  }
}

//
  List<Step> stepList() => [
    //step 1
        Step(
          title: const Text(""),
          isActive: _currentStep >= 0,
          state: _currentStep == 0 ? StepState.editing : StepState.complete,
          content: Form(
            key: _formKey1,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _firstNameController,
                  labelText: 'First Name',
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _middleNameController,
                  labelText: 'Middle Name',
                  prefixIcon: Icons.person,
                   keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your middle name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                   keyboardType: TextInputType.text,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Gender: "),
                    Row(
                      children: [
                        Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Male"),
                        value: "Male",
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Female"),
                        value: "Female",
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                    
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
DatePicker(
  controller: _dateController,
  labelText: 'Date',
  prefixIcon: Icons.calendar_today,
  
  readOnly: true,
  onTap: () async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _dateController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select your date of birth';
    }
    return null;
  },
),

                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                   keyboardType: TextInputType.number,
                  prefixIcon: Icons.phone,
                  // keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length >10 || value.length < 10) {
                      return 'Phone mumber must be 10 digits';
                    } else if 
                    (!RegExp(r'^(09|07)[0-9]{8}$').hasMatch(value)) {
                      return 'Please start  with 09 or 07 ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        //step 2
        Step(
           title: const Text(" "),
          isActive: _currentStep >= 1,
          state: _currentStep == 1 ? StepState.editing : StepState.complete,
          content: Form(
            key: _formKey2,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Region',
                    // prefixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  value: _selectedRegion,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRegion = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select region';
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Addis Ababa',
                      child: Text('Addis Ababa'),
                    ),
                    DropdownMenuItem(
                      value: 'Afar',
                      child: Text('Afar'),
                    ),
                    DropdownMenuItem(
                      value: 'Amhara ',
                      child: Text('Amhara'),
                    ),
                     DropdownMenuItem(
                      value: 'Benishangul-Gumuz ',
                      child: Text('Benishangul-Gumuz'),
                    ),
                     DropdownMenuItem(
                      value: 'Central Ethiopia ',
                      child: Text('Central Ethiopia'),
                    ),
                     DropdownMenuItem(
                      value: 'Dire Dawa ',
                      child: Text('Dire Dawa'),
                    ),
                     DropdownMenuItem(
                      value: 'Gambela ',
                      child: Text('Gambela'),
                    ),
                     DropdownMenuItem(
                      value: 'Harari ',
                      child: Text('Harari'),
                    ),
                     DropdownMenuItem(
                      value: 'Oromia ',
                      child: Text('Oromia'),
                    ),
                    DropdownMenuItem(
                      value: 'Sidama ',
                      child: Text('Sidama'),
                    ),
                    DropdownMenuItem(
                      value: 'Somali ',
                      child: Text('Somali'),
                    ),
                    DropdownMenuItem(
                      value: 'South Ethiopia ',
                      child: Text('South Ethiopia'),
                    ),
                    DropdownMenuItem(
                      value: 'Tigray ',
                      child: Text('Tigray'),
                    ),
  

                  ],
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _zoneController,
                  labelText: 'Zone',
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter zone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _cityController,
                  labelText: 'City',
                   keyboardType: TextInputType.text,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter City';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _woredaController,
                  labelText: 'Woreda',
                   keyboardType: TextInputType.text,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Woreda/Kebele';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
          //step 3
          Step(
           title: const Text(" "),
          isActive: _currentStep >= 2,
          state: _currentStep == 1 ? StepState.editing : StepState.complete,
          content:Form(
      key: _formKey3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           CustomTextFormField(
            controller: _hipWidthController, 
            keyboardType: TextInputType.number ,
            labelText: 'Hip Width', 
            prefixIcon: Icons.straighten,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter hip width';
                }
                return null;
              },
            ),
            // const Text("Hip Width"),
            // CustomTextFormField(
            //   controller: _hipWidthController,
            //   keyboardType: TextInputType.number,
            //   labelText: 'Hip Width',
            //   prefixIcon: Icons.straighten,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter hip width';
            //     }
            //     return null;
            //   },
            // ),
           const SizedBox(height: 10),
            CustomTextFormField(
             controller: _backrestHeightController,
              labelText: 'Backrest Height',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.straighten,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter backrest height';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // const Text("Thigh Length"),
            CustomTextFormField(
              controller: _thighLengthController,
              // keyboardType: TextInputType.number,
              labelText: 'Thigh Length',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.straighten,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter thigh length';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Equipment Type (Radio Buttons)
            // const Text("Equipment Type"),
            // _buildRadioButtonGroup(
            //   options: [
            //     'Pediatric Wheelchair',
            //     'American Wheelchair',
            //     '(FWP) Wheelchair',
            //     'Walker',
            //     'Crutches',
            //     'Cane',
            //   ],
            //   groupValue: _selectedEquipmentType,
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedEquipmentType = value;
            //       if (_selectedEquipmentType != "Pediatric Wheelchair") {
            //         _selectedCause = null; // Reset dropdown if Pediatric is deselected
            //         _customCause = null; // Reset custom cause if deselected
            //       }
            //     });
            //   },
            // ),
            // const Text("Equipment Type"),
DropdownButtonFormField<String>(
  value: _selectedEquipmentType,
  items: [
    'Pediatric Wheelchair',
    'American Wheelchair',
    '(FWP) Wheelchair',
    'Walker',
    'Crutches',
    'Cane',
  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
  onChanged: (value) {
    setState(() {
      _selectedEquipmentType = value;
      if (_selectedEquipmentType != "Pediatric Wheelchair") {
        _selectedCause = null; // Reset dropdown if Pediatric is deselected
        _customCause = null; // Reset custom cause if deselected
      }
    });
  },
  decoration: const InputDecoration(
    hintText: "Select Equipment Type",
    labelText: 'Equipment Type',
    border: OutlineInputBorder(),
  ),
  validator: (value) =>
      value == null ? "Please select an equipment type" : null,
),

            const SizedBox(height: 10),

            // Cause Dropdown (Visible only if Pediatric Wheelchair is selected)
            if (_selectedEquipmentType == "Pediatric Wheelchair") ...[
              // const Text("Cause of Need"),
              
              DropdownButtonFormField<String>(
                value: _selectedCause,
                items: [
                  'Birth Defect',
                  'Injury',
                  'Spinal Cord Issue',
                  'Muscular Dystrophy',
                  'Neurological Disorder',
                  'Amputation',
                  'Cerebral Palsy',
                  'Other',
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCause = value;
                    if (value != "Other") {
                      _customCause = null; // Reset custom text if not "Other"
                    }
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Select Cause",
                   labelText: 'Equipment Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? "Please select a cause" : null,
              ),
              const SizedBox(height: 8),

              // Custom Cause Input (Visible only if "Other" is selected in the dropdown)
              if (_selectedCause == "Other") ...[
                // const Text("Specify Cause"),
                CustomTextFormField(
                  controller: TextEditingController(),
                  // keyboardType: TextInputType.text,
                  labelText: 'Specify Cause',
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.text_fields,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please specify the cause';
                    }
                    return null;
                  },
                ),
              ],
            ],
            const SizedBox(height: 10),

            // Size Selection (Dropdown or Radio Buttons)
            // const Text("Size Selection"),
            DropdownButtonFormField<String>(
              value: _selectedSize,
              items: ['Small', 'Medium', 'Large', 'XL']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSize = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Select Size",
                 labelText: 'Select Size',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null ? "Please select a size" : null,
            ),
            const SizedBox(height: 10),

            // Submit Button
            // ElevatedButton(
            //   onPressed: () {
            //     if (_formKey3.currentState!.validate()) {
            //       // Handle submission logic
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text("Form submitted successfully!")),
            //       );
            //     }
            //   },
            //   child: const Text("Submit"),
            // ),
          ],
        ),
      ),
    )
          ),
          //step 4
   Step(
  title: const Text(""),
  isActive: _currentStep >= 3,
  state: _currentStep == 3 ? StepState.editing : StepState.complete,
  content: Form(
    key: _formKey4,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo Section
          const Text("Photo", style: TextStyle(fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => _pickImage(true),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: _photoFile == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 50),
                          SizedBox(height: 8),
                          Text("Select File"),
                        ],
                      )
                    : Image.file(_photoFile!, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _photoUploadProgress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),

          const SizedBox(height: 20),

          // ID Card Section
          const Text("ID Card", style: TextStyle(fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => _pickImage(false),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: _idCardFile == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 50),
                          SizedBox(height: 8),
                          Text("Select File"),
                        ],
                      )
                    : Image.file(_idCardFile!, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _idCardUploadProgress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),

          const SizedBox(height: 20),

          // Is Provided Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Is Provided"),
              Switch(
                value: isProvided,
                onChanged: (value) {
                  setState(() {
                    isProvided = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Navigation Buttons
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         // Navigate to the previous step
          //         setState(() {
          //           _currentStep -= 1;
          //         });
          //       },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.white,
          //         side: BorderSide(color: Colors.blue),
          //       ),
          //       child: const Text("Back", style: TextStyle(color: Colors.blue)),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         // Validate and go to the next step
          //         if (_photoFile != null &&
          //             _idCardFile != null &&
          //             isProvided) {
          //           setState(() {
          //             _currentStep += 1;
          //           });
          //         } else {
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             const SnackBar(
          //               content:
          //                   Text("Please complete all fields before proceeding."),
          //             ),
          //           );
          //         }
          //       },
          //       child: const Text("NEXT"),
          //     ),
          //   ],
          // ),
        ],
      ),
    ),
  ),
),


        // Add additional steps as required...
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              
              child: Stepper(
                steps: stepList(),
                type: StepperType.horizontal,
                elevation: 5,
                currentStep: _currentStep,
                onStepContinue: () {
                  final isValid = _validateCurrentStep();
          if (isValid && _currentStep < stepList().length - 1) {
                     {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep--;
                    });
                  }
                },
                controlsBuilder: (context, details) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                      TextButton(
                        onPressed: details.onStepCancel,
                             style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                              minimumSize: Size(100, 40), // Button background color
                            foregroundColor: Color.fromRGBO(9, 19, 58, 1), // Text color (blue-black)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Slightly curved edges
                              side: const BorderSide(color: Color.fromRGBO(9, 19, 58, 1), width: 1.5), // Border color and width
                            ),
                                ),
                        child: const Text("Back"),
                      ),
                        // ElevatedButton(
                        //   onPressed: details.onStepCancel,
                        //   child: const Text("Back"),
                        // ),               
                          
          
                      // ElevatedButton(
                      //   onPressed: details.onStepContinue,
                      //   child: const Text("Next"),
                      // ),
          
                      
                         Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             ElevatedButton(
                                onPressed: details.onStepContinue,
                                 style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(9, 19, 58, 1), // Blue-black background color
                                  foregroundColor: Colors.white, // White text color
                                  minimumSize: const Size(100, 40), // Ensures consistent size
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Slightly curved edges
                                  ),
                                ),
                                                   child: const Text("NEXT"),
                                                 ),
                           ],
                         ),
          
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

 // Helper to build Radio Button Group
  Widget _buildRadioButtonGroup({
    required List<String> options,
    required String? groupValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      children: options
          .map((option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
              ))
          .toList(),
    );
  }

  bool _validateCurrentStep() {
  switch (_currentStep) {
    case 0:
      return _formKey1.currentState?.validate() ?? false;
    case 1:
      return _formKey2.currentState?.validate() ?? false;
      case 2:
      return _formKey3.currentState?.validate() ?? false;
    default:
      return false;
  }
}

}

// class CustomTextFormField extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final IconData prefixIcon;
//   final TextInputType? keyboardType;
//   final bool readOnly;
//   final VoidCallback? onTap;
//   final String? Function(String?)? validator;

//   const CustomTextFormField({
//     Key? key,
//     required this.controller,
//     required this.labelText,
//     required this.prefixIcon,
//     this.keyboardType,
//     this.readOnly = false,
//     this.onTap,
//     this.validator,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       readOnly: readOnly,
//       onTap: onTap,
//       decoration: InputDecoration(
//         prefixIcon: Icon(prefixIcon),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         labelText: labelText,
//       ),
//       validator: validator,
//     );
//   }
// }

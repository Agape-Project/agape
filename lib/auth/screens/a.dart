// Step(
//   title: const Text(""),
//   isActive: _currentStep >= 3,
//   state: _currentStep == 3 ? StepState.editing : StepState.complete,
//   content: Form(
//     key: _formKey4,
//     child: SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Photo Section
//           const Text("Photo", style: TextStyle(fontWeight: FontWeight.bold)),
//           GestureDetector(
//             onTap: () => _pickImage(true),
//             child: Container(
//               height: 150,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Center(
//                 child: _photoFile == null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.upload_file, size: 50),
//                           const SizedBox(height: 8),
//                           const Text("Select File"),
//                         ],
//                       )
//                     : Image.file(_photoFile!, fit: BoxFit.cover),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: _photoUploadProgress,
//             backgroundColor: Colors.grey[300],
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//           ),

//           const SizedBox(height: 20),

//           // ID Card Section
//           const Text("ID Card", style: TextStyle(fontWeight: FontWeight.bold)),
//           GestureDetector(
//             onTap: () => _pickImage(false),
//             child: Container(
//               height: 150,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Center(
//                 child: _idCardFile == null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.upload_file, size: 50),
//                           const SizedBox(height: 8),
//                           const Text("Select File"),
//                         ],
//                       )
//                     : Image.file(_idCardFile!, fit: BoxFit.cover),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: _idCardUploadProgress,
//             backgroundColor: Colors.grey[300],
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//           ),

//           const SizedBox(height: 20),

//           // Is Provided Switch
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text("Is Provided"),
//               Switch(
//                 value: isProvided,
//                 onChanged: (value) {
//                   setState(() {
//                     isProvided = value;
//                   });
//                 },
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           // Navigation Buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   // Navigate to the previous step
//                   setState(() {
//                     _currentStep -= 1;
//                   });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   side: BorderSide(color: Colors.blue),
//                 ),
//                 child: const Text("Back", style: TextStyle(color: Colors.blue)),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Validate and go to the next step
//                   if (_photoFile != null &&
//                       _idCardFile != null &&
//                       isProvided) {
//                     setState(() {
//                       _currentStep += 1;
//                     });
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content:
//                             Text("Please complete all fields before proceeding."),
//                       ),
//                     );
//                   }
//                 },
//                 child: const Text("NEXT"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   ),
// ),

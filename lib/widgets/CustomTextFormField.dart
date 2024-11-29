import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  

  // Constructor
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.labelText,
    required this.prefixIcon,
    this.validator,
    this.obscureText = false,
  
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
      ),
      validator: validator,
    );
  }
}

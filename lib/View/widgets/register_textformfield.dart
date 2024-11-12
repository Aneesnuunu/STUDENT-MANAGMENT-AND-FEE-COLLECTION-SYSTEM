import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final ValueChanged<String?>? onChanged;
  final TextEditingController? controller;
  final bool? enabled; // Add enabled parameter

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.isDropdown = false,
    this.dropdownItems,
    this.onChanged,
    this.controller,
    this.enabled, // Add this parameter to the constructor
  });

  @override
  Widget build(BuildContext context) {
    if (isDropdown) {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: Icon(icon),
        items: dropdownItems?.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled, // Use the enabled property here
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: validator,
    );
  }
}

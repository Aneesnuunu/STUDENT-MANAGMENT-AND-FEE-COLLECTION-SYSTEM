import 'package:flutter/material.dart';

import '../../generated/theme.dart';

class CustomCircleAvatar extends StatelessWidget {
  final IconData icon; // The icon to be displayed inside the circle
  final String label;
  final VoidCallback onPressed; // Callback for the icon tap

  const CustomCircleAvatar({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed, // onPressed callback for navigation
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Trigger the onPressed callback when tapped
      child:Column(
        children: [
          CircleAvatar(
            radius: 40, // Set the radius to 40
            backgroundColor:AppThemes.lightTheme.primaryColor, // White background
            child: Icon(
              icon,
              color: Colors.white, // Fixed green color for the icon
              size: 50, // Icon size can be adjusted as needed
            ),
          ),
          const SizedBox(height: 8), // Space between avatar and text
          Text(label,
          style: AppThemes.lightTheme.textTheme.bodyMedium,
          )

        ],

      )


    );
  }
}

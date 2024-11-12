import 'package:education_institution/generated/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_bar.dart'; // Import your custom AppBar widget

class OldStudentDetailPage extends StatelessWidget {
  final Map<String, dynamic> student;

  const OldStudentDetailPage({super.key, required this.student});

  void _openReceiptUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Student Details - ${student['name']}'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: student['imageUrl'] != null
                      ? NetworkImage(student['imageUrl'])
                      : const AssetImage('assets/images/default_student.png') as ImageProvider,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: AppThemes.lightTheme.primaryColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${student['name']}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Divider(color: Colors.white70),
                      _buildInfoRow('Admission Number', student['admissionNumber']),
                      _buildInfoRow('Course', student['course']),
                      _buildInfoRow('Age', student['age']),
                      _buildInfoRow('Phone', student['phone']),
                      _buildInfoRow('Email', student['email']),
                      _buildInfoRow('Address', student['address']),
                      _buildInfoRow('Blood Group', student['bloodGroup']),
                      _buildInfoRow('Date of Registration', student['date']),
                      _buildInfoRow('Course Duration', '${student['duration']} year(s)'),
                      const Divider(color: Colors.white70),
                      _buildInfoRow('Total Fee', '₹${student['fee']}'),
                      _buildInfoRow('Paid Amount', '₹${student['paidAmount']}'),
                      _buildInfoRow('Balance Amount', '₹${student['balanceAmount']}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Receipts:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              student['receipts'] != null && student['receipts'] is List
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (student['receipts'] as List).map<Widget>((receiptUrl) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      onPressed: () => _openReceiptUrl(receiptUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.lightTheme.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'View Receipt',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
                  : Text('No Receipts Available', style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Text(
            value != null ? value.toString() : 'N/A',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

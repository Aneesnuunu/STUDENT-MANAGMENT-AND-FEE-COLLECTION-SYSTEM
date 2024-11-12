import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_institution/View/widgets/register_textformfield.dart';
import 'package:education_institution/generated/theme.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import 'o3_bill.dart';

class Fee extends StatefulWidget {
  const Fee({super.key});

  @override
  State<Fee> createState() => _FeeState();
}

class _FeeState extends State<Fee> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController feeController = TextEditingController(); // Controller for fee input
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> studentsData = []; // To hold student data
  Map<String, dynamic>? selectedStudent; // To hold the selected student data

  void _fetchStudents(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z') // Ensure we fetch names starting with the query
          .get();

      studentsData = querySnapshot.docs.map((doc) {
        // print('Fetched Student ID: ${doc.id}'); // Log the document ID
        return {'id': doc.id, ...doc.data()}; // Include the document ID in the data
      }).toList();

      setState(() {});
    } catch (e) {
      // print('Error fetching student data by name: $e');
    }
  }

  void _fetchStudentsByAdmissionNumber(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('admissionNumber', isEqualTo: query)
          .get();

      studentsData = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {});
    } catch (e) {
      // print('Error fetching student data by admission number: $e');
    }
  }

  void _collectFee() async {
    if (selectedStudent == null || feeController.text.isEmpty) {
      // Add proper error handling here, e.g., show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a student and enter a fee amount.')),
      );
      return;
    }

    double feeAmount = double.tryParse(feeController.text) ?? 0;
    double paidAmount = selectedStudent!['paidAmount'] ?? 0;
    double totalFee = selectedStudent!['fee'] ?? 0;
    double balanceAmount = totalFee - (paidAmount + feeAmount);

    // Check if student exists in Firebase before updating
    DocumentReference studentRef = _firestore.collection('students').doc(selectedStudent!['id']);
    DocumentSnapshot studentDoc = await studentRef.get();

    if (studentDoc.exists) {
      await studentRef.update({
        'paidAmount': paidAmount + feeAmount,
        'balanceAmount': balanceAmount,
      });

      // Generate a receipt ID and get the current date/time
      String receiptId = DateTime.now().millisecondsSinceEpoch.toString(); // Example receipt ID
      DateTime dateTime = DateTime.now();

      // Navigate to Bill page, passing the necessary data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Bill(
            studentName: selectedStudent!['name'] ?? 'Unknown',
            admissionNumber: selectedStudent!['admissionNumber'] ?? 'Unknown',
            course: selectedStudent!['course'] ?? 'Unknown',
            feeAmount: feeAmount,
            balanceAmount: balanceAmount,
            paidAmount: paidAmount + feeAmount, // Updated paid amount
            receiptId: receiptId,
            dateTime: dateTime,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Student document not found!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      String searchQuery = searchController.text.trim();
      if (searchQuery.isNotEmpty) {
        if (RegExp(r'^[0-9]+$').hasMatch(searchQuery)) {
          _fetchStudentsByAdmissionNumber(searchQuery);
        } else {
          _fetchStudents(searchQuery);
        }
      } else {
        setState(() {
          studentsData.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    feeController.dispose(); // Dispose of the fee controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Fee Collect",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextFormField(
              labelText: "Search by Name or Admission Number",
              icon: Icons.search,
              controller: searchController,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              labelText: "Enter Fee Amount",
              icon: Icons.monetization_on,
              controller: feeController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: studentsData.length,
                itemBuilder: (context, index) {
                  final student = studentsData[index];
                  bool isSelected = selectedStudent?['id'] == student['id']; // Check if this student is selected
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStudent = student; // Set selected student
                      });
                    },
                    child: SingleChildScrollView(
                      child: Card(
                        color: isSelected ? Colors.blue : AppThemes.lightTheme.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: student['imageUrl'] != null
                                    ? NetworkImage(student['imageUrl'])
                                    : null,
                                radius: 40,
                                child: student['imageUrl'] == null
                                    ? Icon(Icons.person, size: 40)
                                    : null,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${student['name']}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                '${student['admissionNumber']}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text('${student['course']}', style: TextStyle(color: Colors.white)),
                              Text('Fee: ${student['fee']}', style: TextStyle(color: Colors.white)),
                              Text('Paid Amount: ${student['paidAmount']}', style: TextStyle(color: Colors.white)),
                              Text('Balance: ${student['balanceAmount']}', style: TextStyle(color: Colors.white)),
                              if (isSelected) // Show the tick icon when selected
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.check_circle, color: Colors.blue, size: 30),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes.lightTheme.primaryColor),
              onPressed: _collectFee,
              child: Text('Collect Fee',style: TextStyle(color: Colors.white),),

            ),
          ],
        ),
      ),
    );
  }
}

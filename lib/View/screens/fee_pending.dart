import 'package:education_institution/generated/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_bar.dart';

class FeePending extends StatefulWidget {
  const FeePending({super.key});

  @override
  _FeePendingState createState() => _FeePendingState();
}

class _FeePendingState extends State<FeePending> {
  List<DocumentSnapshot> _pendingStudents = [];
  String? _selectedCourse; // Holds the selected course
  final List<String> _courses = ['All', 'Science', 'English', 'Mathematics', 'Computer Science'];

  @override
  void initState() {
    super.initState();
    _fetchPendingFeeStudents(); // Fetch all fee pending students on initialization
  }

  Future<void> _fetchPendingFeeStudents() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('balanceAmount', isGreaterThan: 0)
          .orderBy('balanceAmount', descending: true) // Sorting by balance in decreasing order
          .get();

      setState(() {
        _pendingStudents = snapshot.docs; // Store the students with pending fees
      });
    } catch (e) {
      print("Error fetching fee pending students: $e");
    }
  }

  void _filterStudentsByCourse() {
    if (_selectedCourse != null && _selectedCourse != 'All') {
      // Filter the students by the selected course
      setState(() {
        _pendingStudents = _pendingStudents.where((student) {
          return student['course'] == _selectedCourse;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Fee Pending Students",
        onBackPressed: () {
          Navigator.pop(context); // Go back to the previous screen
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown to select a course filter
            DropdownButton<String>(
              value: _selectedCourse,
              hint: Text('Select Course'),
              isExpanded: true,
              items: _courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCourse = newValue;
                  _fetchPendingFeeStudents().then((_) => _filterStudentsByCourse()); // Fetch and filter
                });
              },
            ),
            SizedBox(height: 20),
            _pendingStudents.isEmpty
                ? Center(child: Text('No students with pending fees'))
                : Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items in a row
                  childAspectRatio: 0.75, // Aspect ratio for items
                ),
                itemCount: _pendingStudents.length,
                itemBuilder: (context, index) {
                  var student = _pendingStudents[index];
                  return SingleChildScrollView(
                    child: Card(
                      color: AppThemes.lightTheme.primaryColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Display student image with fallback to a common image
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: student['imageUrl'] != null
                                  ? NetworkImage(student['imageUrl'])
                                  : AssetImage('assets/images/default_student.png'),
                            ),
                            SizedBox(height: 10),
                            // Display student name
                            Text(
                              student['name'] ?? 'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Display student phone number
                            Text(
                              '${student['phone'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            // Display total fee
                            Text(
                              'Total Fee: ₹${student['fee'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            // Display balance amount (pending fee)
                            Text(
                              'Balance: ₹${student['balanceAmount'] ?? 0}',
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            ),
                            SizedBox(height: 8),
                            // Display course
                            Text(
                              '${student['course'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            // Display student admission number
                            Text(
                              'Admission No: ${student['admissionNumber'] ?? 'N/A'}',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

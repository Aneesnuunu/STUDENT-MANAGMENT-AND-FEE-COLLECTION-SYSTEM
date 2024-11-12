import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../generated/theme.dart';

class CloseAccount extends StatefulWidget {
  const CloseAccount({super.key});

  @override
  CloseAccountState createState() => CloseAccountState();
}

class CloseAccountState extends State<CloseAccount> {
  List<DocumentSnapshot> _students = [];
  List<DocumentSnapshot> selectedStudents = [];

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('students').get();
      setState(() {
        _students = snapshot.docs;
      });
    } catch (e) {
      // print("Error fetching student data: $e");
    }
  }

  void _toggleSelection(DocumentSnapshot student) {
    setState(() {
      if (selectedStudents.contains(student)) {
        selectedStudents.remove(student);
      } else {
        selectedStudents.add(student);
      }
    });
  }

  Future<void> _moveToOldStudents() async {
    try {
      for (var student in selectedStudents) {
        // Step 1: Add student to "oldstudent" collection
        await FirebaseFirestore.instance.collection('oldstudent').doc(student.id).set(student.data() as Map<String, dynamic>);

        // Step 2: Delete student from "students" collection
        await FirebaseFirestore.instance.collection('students').doc(student.id).delete();
      }

      setState(() {
        // Refresh list by removing the moved students
        _students.removeWhere((student) => selectedStudents.contains(student));
        selectedStudents.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected students moved to oldstudent collection successfully")),
      );
    } catch (e) {
      // print("Error moving students: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to move students")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Close Account',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppThemes.lightTheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white), // Set back arrow color to white
        actions: [
          if (selectedStudents.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white), // Optional: ensure the delete icon is also white
              onPressed: _moveToOldStudents,
            ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _students.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: _students.length,
          itemBuilder: (context, index) {
            var student = _students[index];
            bool isSelected = selectedStudents.contains(student);

            return GestureDetector(
              onTap: () => _toggleSelection(student),
              child: Card(

                color: isSelected ? Colors.blue.withOpacity(0.5) : AppThemes.lightTheme.primaryColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: student['imageUrl'] != null
                            ? NetworkImage(student['imageUrl'])
                            : null,
                        child: student['imageUrl'] == null
                            ? Icon(Icons.person, size: 40, color: Colors.grey[700])
                            : null,
                      ),
                      SizedBox(height: 10),
                      Text(
                        student['name'] ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Adm No: ${student['admissionNumber'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Balance: ₹${student['balanceAmount'] ?? 0}',
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

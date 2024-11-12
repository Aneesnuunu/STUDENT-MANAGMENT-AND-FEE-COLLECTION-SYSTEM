import 'package:education_institution/generated/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_bar.dart';
import 'o5_oldstudentdetailpage.dart';

class OldStudent extends StatefulWidget {
  const OldStudent({super.key});

  @override
  OldStudentState createState() => OldStudentState();
}

class OldStudentState extends State<OldStudent> {
  List<DocumentSnapshot> _oldStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOldStudents();
  }

  Future<void> _fetchOldStudents() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('oldstudent').get();

      setState(() {
        _oldStudents = snapshot.docs;
        _isLoading = false; // Data loaded, stop loading indicator
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading indicator on error
      });
      // Handle the error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Old Student Details",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : _oldStudents.isEmpty
                ? Center(child: Text('No old student records found'))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _oldStudents.length,
                    itemBuilder: (context, index) {
                      var student = _oldStudents[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OldStudentDetailPage(
                                student: student.data() as Map<String, dynamic>,
                              ),
                            ),
                          );
                        },
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
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      student['imageUrl'] != null &&
                                              student['imageUrl'] != ''
                                          ? NetworkImage(student['imageUrl'])
                                          : AssetImage('assets/img.png')
                                              as ImageProvider,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  student['name'] ?? 'N/A',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Adm. No: ${student['admissionNumber'] ?? 'N/A'}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  'Balance: ₹${student['balanceAmount'] ?? 0}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.red),
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

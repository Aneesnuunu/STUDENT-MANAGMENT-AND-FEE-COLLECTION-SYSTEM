import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_bar.dart';
import '../../generated/theme.dart';
import 'o4_edit_details.dart';

class StudentDetailsPage extends StatefulWidget {
  final String studentId;

  const StudentDetailsPage({super.key, required this.studentId});

  @override
  StudentDetailsPageState createState() => StudentDetailsPageState();
}

class StudentDetailsPageState extends State<StudentDetailsPage> {
  DocumentSnapshot? studentData;

  @override
  void initState() {
    super.initState();
    _fetchStudentDetails();
  }

  Future<void> _fetchStudentDetails() async {
    studentData = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Student Details",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: studentData != null
              ? Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(studentData!['imageUrl']),
                      ),
                      SizedBox(height: 20),
                      Text(
                        studentData!['name'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Admission No: ${studentData!['admissionNumber']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Course: ${studentData!['course']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Duration: ${studentData!['duration']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Phone: ${studentData!['phone']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Email: ${studentData!['email']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Age: ${studentData!['age'].toString()}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Address: ${studentData!['address']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Blood Group: ${studentData!['bloodGroup']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Fee: ₹${studentData!['fee'].toString()}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Paid Amount: ₹${studentData!['paidAmount'].toString()}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Balance Amount: ₹${studentData!['balanceAmount'].toString()}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditStudentPage(
                                studentId: widget.studentId,
                                studentData:
                                    studentData!.data() as Map<String, dynamic>,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppThemes.lightTheme.primaryColor,
                        ),
                        child: Text(
                          "Edit Student",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

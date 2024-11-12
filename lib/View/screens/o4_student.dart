import 'package:education_institution/generated/theme.dart';
import 'package:education_institution/View/screens/o4_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _students = [];
  List<DocumentSnapshot> _allStudents = []; // List to hold all students
  String _sortOption = 'Alphabetical'; // Default sort option

  @override
  void initState() {
    super.initState();
    _fetchAllStudents(); // Fetch all students on initialization
  }

  Future<void> _fetchAllStudents() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('students').get();
    setState(() {
      _allStudents = snapshot.docs; // Store all retrieved students
      _students = _allStudents; // Initialize _students with all students
    });
  }

  Future<void> _searchStudents(String query) async {
    if (query.isNotEmpty) {
      QuerySnapshot snapshot;

      // Search for names starting with the query
      snapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        _students = snapshot.docs; // Store the retrieved students
      });
    } else {
      setState(() {
        _students = _allStudents; // Reset to show all students if query is empty
      });
    }
    _sortStudents(); // Sort the list after searching
  }

  void _sortStudents() {
    // Sort students based on selected option
    switch (_sortOption) {
      case 'Alphabetical':
        _students.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Admission Number':
        _students.sort((a, b) => a['admissionNumber'].compareTo(b['admissionNumber']));
        break;
      case 'Date of Join':
        _students.sort((a, b) => (a['dateTime'] as Timestamp).compareTo(b['dateTime'] as Timestamp));
        break;
      case 'Course':
        _students.sort((a, b) => a['course'].compareTo(b['course']));
        break;
      case 'Blood Group':
        _students.sort((a, b) => a['bloodGroup'].compareTo(b['bloodGroup']));
        break;
    // Add additional case for Course Batch and Blood Group sorting if needed
      default:
        break;
    }
  }

  // Function to show sorting options
  void _showSortingOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sort By"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<String>(
                title: Text("Alphabetical"),
                value: 'Alphabetical',
                groupValue: _sortOption,
                onChanged: (String? value) {
                  setState(() {
                    _sortOption = value!;
                    _sortStudents(); // Sort when the option changes
                  });
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
              RadioListTile<String>(
                title: Text("Admission Number"),
                value: 'Admission Number',
                groupValue: _sortOption,
                onChanged: (String? value) {
                  setState(() {
                    _sortOption = value!;
                    _sortStudents(); // Sort when the option changes
                  });
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
              // RadioListTile<String>(
              //   title: Text("Date of Join"),
              //   value: 'Date of Join',
              //   groupValue: _sortOption,
              //   onChanged: (String? value) {
              //     setState(() {
              //       _sortOption = value!;
              //       _sortStudents(); // Sort when the option changes
              //     });
              //     Navigator.of(context).pop(); // Close dialog
              //   },
              // ),
              RadioListTile<String>(
                title: Text("Course"),
                value: 'Course',
                groupValue: _sortOption,
                onChanged: (String? value) {
                  setState(() {
                    _sortOption = value!;
                    _sortStudents(); // Sort when the option changes
                  });
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
              RadioListTile<String>(
                title: Text("Blood Group"),
                value: 'Blood Group',
                groupValue: _sortOption,
                onChanged: (String? value) {
                  setState(() {
                    _sortOption = value!;
                    _sortStudents(); // Sort when the option changes
                  });
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Student Details",
        onBackPressed: () {
          Navigator.pop(context); // Go back to the previous screen
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search by Name or Admission Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _searchStudents(value); // Call the search function on input change
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  var student = _students[index]; // Get the current student document
                  return GestureDetector(
                    onTap: () {
                      // Ensure you're passing `student.id`
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDetailsPage(studentId: student.id),
                        ),
                      );
                    },
                    child: Card(
                      color: AppThemes.lightTheme.primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Display the student image in a circular avatar
                          CircleAvatar(
                            backgroundImage: NetworkImage(student['imageUrl']),
                            radius: 50, // Adjust the radius as needed
                          ),
                          SizedBox(height: 10),
                          Text(
                            student['name'],
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            "${student['admissionNumber']}",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          // Text(
                          //   "Date of Join: ${student['dateTime'].toDate().toLocal()}".split(' ')[0],
                          //   style: TextStyle(fontSize: 12, color: Colors.white),
                          // ),
                          Text(
                            "Course: ${student['course']}",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSortingOptions,
        child: Icon(Icons.sort),
      ),
    );
  }
}

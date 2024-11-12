import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_bar.dart';
import '../widgets/edit_textformfield.dart';
import '../../generated/theme.dart';

class EditStudentPage extends StatefulWidget {
  final String studentId;

  const EditStudentPage({
    super.key,
    required this.studentId, required Map<String, dynamic> studentData,
  });

  @override
  EditStudentPageState createState() => EditStudentPageState();
}

class EditStudentPageState extends State<EditStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  String? selectedBloodGroup;
  String? balanceAmount = "0.00"; // Initialize balance amount

  @override
  void initState() {
    super.initState();
    _fetchStudentData();

    // Add listener to recalculate balance whenever paid amount or fee changes
    paidAmountController.addListener(_calculateBalance);
    feeController.addListener(_calculateBalance);
  }

  Future<void> _fetchStudentData() async {
    DocumentSnapshot studentData = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .get();

    setState(() {
      nameController.text = studentData['name'] ?? '';
      phoneController.text = studentData['phone'] ?? '';
      emailController.text = studentData['email'] ?? '';
      addressController.text = studentData['address'] ?? '';
      ageController.text = studentData['age'].toString();
      courseController.text = studentData['course'] ?? '';
      feeController.text = studentData['fee'].toString();
      paidAmountController.text = studentData['paidAmount'].toString();
      balanceAmount = studentData['balanceAmount'].toString();
      selectedBloodGroup = studentData['bloodGroup'];
    });
  }

  void _calculateBalance() {
    double fee = double.tryParse(feeController.text) ?? 0;
    double paidAmount = double.tryParse(paidAmountController.text) ?? 0;
    double balance = fee - paidAmount;
    setState(() {
      balanceAmount = balance.toStringAsFixed(2); // Update balance amount
    });
  }

  Future<void> _updateStudentData() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.studentId)
          .update({
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'address': addressController.text,
        'age': int.parse(ageController.text),
        'course': courseController.text,
        'fee': double.parse(feeController.text),
        'paidAmount': double.parse(paidAmountController.text),
        'balanceAmount': double.parse(balanceAmount!), // Store calculated balance
        'bloodGroup': selectedBloodGroup,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student details updated successfully!')),
      );
      Navigator.pop(context); // Go back after updating
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit Details",
        onBackPressed: () {
          Navigator.pop(context); // Go back to the previous screen
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFormFieldEdit(
                  controller: nameController,
                  labelText: "Name",
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter name';
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextFormFieldEdit(
                  controller: phoneController,
                  labelText: "Phone",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter phone number';
                    if (value.length != 10) return 'Enter a valid phone number';
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextFormFieldEdit(
                  controller: emailController,
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter email';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextFormFieldEdit(
                  controller: addressController,
                  labelText: "Address",
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter address';
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextFormFieldEdit(
                  controller: ageController,
                  labelText: "Age",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter age';
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  hint: Text('Select a course'),
                  value: courseController.text.isEmpty
                      ? null
                      : courseController.text,
                  items: [
                    'Mathematics',
                    'Science',
                    'English',
                    'Computer Science',
                    'Physics',
                    'Chemistry'
                  ].map((course) {
                    return DropdownMenuItem<String>(
                      value: course,
                      child: Text(course),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      courseController.text = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Course",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                  value == null ? 'Please select a course' : null,
                ),
                SizedBox(height: 10),
                CustomTextFormFieldEdit(
                  controller: feeController,
                  labelText: "Fee",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter fee';
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextFormFieldEdit(
                  controller: paidAmountController,
                  labelText: "Paid Amount",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter paid amount';
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Remove the balance amount field as it's calculated automatically
                TextFormField(
                  enabled: false, // Make it read-only
                  decoration: InputDecoration(
                    labelText: "Balance Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: balanceAmount, // Display calculated balance
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  hint: Text('Select blood group'),
                  value: selectedBloodGroup,
                  items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                      .map((group) {
                    return DropdownMenuItem<String>(
                      value: group,
                      child: Text(group),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBloodGroup = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Blood Group",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                  value == null ? 'Please select blood group' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateStudentData,
                  style: ElevatedButton.styleFrom( backgroundColor: AppThemes.lightTheme.primaryColor),

                  child: Text("Update",style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

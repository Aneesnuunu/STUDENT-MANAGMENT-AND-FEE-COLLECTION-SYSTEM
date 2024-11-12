import 'dart:math';
import 'dart:io'; // Import for File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import for Image Picker
import '../../generated/theme.dart';
import '../widgets/app_bar.dart';
import '../widgets/register_textformfield.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance; // Firebase Storage instance
  String? selectedCourse;
  String? selectedBloodGroup;
  String admissionNumber = "";
  String currentDateTime = "";
  File? _selectedImage; // Variable to hold the selected image
  bool _isLoading = false; // Variable to manage loading state

  // Define controllers for each text field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController paidamountController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    admissionNumber = _generateAdmissionNumber();
    currentDateTime = _getCurrentDateTime();
  }

  String _generateAdmissionNumber() {
    final random = Random();
    return random.nextInt(90000).toString().padLeft(5, '0');
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Set the selected image
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_selectedImage == null) return ''; // Return empty string if no image

    // Create a unique file name
    String fileName =
        'students/${admissionNumber}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Upload the image to Firebase Storage
    try {
      await _storage.ref(fileName).putFile(_selectedImage!);
      String downloadUrl = await _storage.ref(fileName).getDownloadURL();
      return downloadUrl; // Return the download URL
    } catch (e) {
      return ''; // Handle error during upload
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "New Student Registration",
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  "Admission Number: $admissionNumber",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Date & Time: $currentDateTime",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.lightTheme.primaryColor),
                  child: Text(
                    _selectedImage == null ? 'Upload Image' : 'Change Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.file(
                      _selectedImage!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: nameController,
                  labelText: "Name",
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: phoneController,
                  labelText: "Phone",
                  icon: Icons.phone,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: emailController,
                  labelText: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: addressController,
                  labelText: "Address",
                  icon: Icons.place,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: ageController,
                  labelText: "Age",
                  icon: Icons.celebration,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Age';
                    }
                    // Ensure 'age' is an integer
                    try {
                      int.parse(value);
                    } catch (_) {
                      return 'Age must be a number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  labelText: "Course Name",
                  icon: Icons.school,
                  isDropdown: true,
                  dropdownItems: [
                    'Mathematics',
                    'Science',
                    'English',
                    'Computer Science'
                  ],
                  onChanged: (value) {
                    selectedCourse = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Course';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: durationController,
                  labelText: "Duration",
                  icon: Icons.timelapse,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Duration';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: feeController,
                  labelText: "Fee",
                  icon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Fee';
                    }
                    // Ensure 'fee' is a number
                    try {
                      double.parse(value);
                    } catch (_) {
                      return 'Fee must be a number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: paidamountController,
                  labelText: "Paid Amount",
                  icon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Paid Amount';
                    }
                    // Ensure 'paidAmount' is a number
                    try {
                      double.parse(value);
                    } catch (_) {
                      return 'Paid Amount must be a number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: balanceController,
                  labelText: "Balance Amount",
                  icon: Icons.account_balance_wallet,
                  enabled: false, // Set enabled to false to make it read-only
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  labelText: "Blood Group",
                  icon: Icons.bloodtype,
                  isDropdown: true,
                  dropdownItems: [
                    'A+',
                    'B+',
                    'O+',
                    'AB+',
                    'A-',
                    'B-',
                    'O-',
                    'AB-'
                  ],
                  onChanged: (value) {
                    selectedBloodGroup = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a Blood Group';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateBalance,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.lightTheme.primaryColor), // Calculate balance on press
                  child: Text("Calculate Balance",
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.lightTheme.primaryColor),
                  child: Text(
                    _isLoading ? "Saving..." : "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _calculateBalance() {
    if (feeController.text.isNotEmpty && paidamountController.text.isNotEmpty) {
      double fee = double.tryParse(feeController.text) ?? 0;
      double paidAmount = double.tryParse(paidamountController.text) ?? 0;
      double balance = fee - paidAmount;
      balanceController.text =
          balance.toStringAsFixed(2); // Update balance field
    } else {
      balanceController.text = '0.00'; // Default balance
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading state
      });

      String imageUrl = await _uploadImage(); // Upload image and get URL

      // Add student data to Firestore with admission number as document ID
      try {
        await _firestore.collection('students').doc(admissionNumber).set({
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'address': addressController.text,
          'age': int.tryParse(ageController.text),
          'course': selectedCourse,
          'duration': durationController.text,
          'fee': double.tryParse(feeController.text),
          'paidAmount': double.tryParse(paidamountController.text),
          'balanceAmount': double.tryParse(balanceController.text),
          'bloodGroup': selectedBloodGroup,
          'admissionNumber': admissionNumber,
          'dateTime': currentDateTime,
          'imageUrl': imageUrl, // Store image URL
        });

        // Reset the form fields
        _formKey.currentState!.reset();
        nameController.clear();
        phoneController.clear();
        emailController.clear();
        addressController.clear();
        ageController.clear();
        durationController.clear();
        feeController.clear();
        paidamountController.clear();
        balanceController.clear();
        selectedCourse = null; // Reset course selection
        selectedBloodGroup = null; // Reset blood group selection
        _selectedImage = null; // Reset image

        // Optionally, generate a new admission number and current date/time for the next entry
        admissionNumber = _generateAdmissionNumber();
        currentDateTime = _getCurrentDateTime();

        setState(() {
          _isLoading = false; // Hide loading state
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student Registered Successfully!')));
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading state
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

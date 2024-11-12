import 'dart:typed_data'; // For ByteData and Uint8List
import 'dart:ui' as ui; // For ui.Image
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:share_plus/share_plus.dart';

import '../../generated/theme.dart';

class Bill extends StatefulWidget {
  final String studentName;
  final String admissionNumber;
  final String course;
  final double feeAmount;
  final double balanceAmount;
  final double paidAmount;
  final String receiptId;
  final DateTime dateTime;

  const Bill({
    super.key,
    required this.studentName,
    required this.admissionNumber,
    required this.course,
    required this.feeAmount,
    required this.balanceAmount,
    required this.paidAmount,
    required this.receiptId,
    required this.dateTime,
  });

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  final GlobalKey _globalKey = GlobalKey(); // GlobalKey for screenshot

  // Function to capture and save screenshot
  Future<void> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      File imgFile = File('${directory.path}/receipt_${widget.receiptId}_${DateTime.now().millisecondsSinceEpoch}.png');

      // Create the file if it does not exist
      if (!(await imgFile.exists())) {
        await imgFile.create(recursive: true);
      }

      await imgFile.writeAsBytes(pngBytes);

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('student_receipts/${widget.admissionNumber}/receipt_${widget.receiptId}_${DateTime.now().millisecondsSinceEpoch}.png');
      await storageRef.putFile(imgFile);

      // Get the download URL for the uploaded image
      final String downloadUrl = await storageRef.getDownloadURL();

      // Save receipt URL to Firestore
      await FirebaseFirestore.instance.collection('students').doc(widget.admissionNumber).update({
        'receipts': FieldValue.arrayUnion([downloadUrl]), // Add new URL to the list
      });

      // Create XFile from the imgFile path for sharing
      final List<XFile> xFiles = [XFile(imgFile.path)];

      // Share the receipt image via email
      await Share.shareXFiles(xFiles, text: 'Here is your receipt.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receipt saved successfully and ready to share!')),
      );
    } catch (e) {
      // print(e); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save receipt: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: RepaintBoundary(
            key: _globalKey, // Wrap the content inside RepaintBoundary
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "ABC TUITION CENTER",
                    style: AppThemes.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text("APJ Building, Near Bus Stand, Malappuram, 673698"),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text("Phone Number: 9989656985", style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.black, thickness: 2),
                SizedBox(height: 10),

                // Displaying Receipt Details
                Text(
                  "Receipt ID: ${widget.receiptId}",
                  style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Date: ${widget.dateTime.toLocal()}",
                  style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontSize: 16),
                ),
                SizedBox(height: 10),

                // Displaying Student Details
                Text(
                  "Student Details",
                  style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Name: ${widget.studentName}", style: AppThemes.lightTheme.textTheme.bodyLarge),
                Text("Admission Number: ${widget.admissionNumber}", style: AppThemes.lightTheme.textTheme.bodyLarge),
                Text("Course: ${widget.course}", style: AppThemes.lightTheme.textTheme.bodyLarge),
                SizedBox(height: 10),

                Divider(color: Colors.black, thickness: 1),
                SizedBox(height: 10),

                // Table Header
                Text(
                  "Fee Breakdown",
                  style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Table with 3 Columns
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("S.No", style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Description", style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Amount", style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("1", style: AppThemes.lightTheme.textTheme.bodyLarge),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Tuition Fee", style: AppThemes.lightTheme.textTheme.bodyLarge),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("₹ ${widget.feeAmount}", style: AppThemes.lightTheme.textTheme.bodyLarge),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Divider(color: Colors.black, thickness: 2),

                // Displaying Paid Amount and Balance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Paid Amount:", style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontSize: 16)),
                    Text("₹ ${widget.paidAmount}", style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Balance Amount:", style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontSize: 16)),
                    Text("₹ ${widget.balanceAmount}", style: AppThemes.lightTheme.textTheme.bodyLarge!.copyWith(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 20),

                Divider(color: Colors.black, thickness: 2),

                // Thank You Message
                Center(
                  child: Text(
                    "Thank you for your payment!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 150),

                // Save Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.lightTheme.primaryColor),
                    onPressed: _captureScreenshot, // Call the function to capture and save screenshot
                    child: Text('Save',style:TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

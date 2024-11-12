// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../widgets/app_bar.dart';
// import 'otp_screen.dart';
//
// class PhoneAuth extends StatefulWidget {
//   const PhoneAuth({super.key});
//
//   @override
//   State<PhoneAuth> createState() => _PhoneAuthState();
// }
//
// class _PhoneAuthState extends State<PhoneAuth> {
//   TextEditingController phoneController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: 'Login Page'),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 hintText: 'Enter Phone Number',
//                 prefixText: '+91 ',
//                 suffixIcon: Icon(Icons.phone),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//               ),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.verifyPhoneNumber(
//                   phoneNumber: '+91${phoneController.text}',
//                   verificationCompleted: (PhoneAuthCredential credential) {},
//                   verificationFailed: (FirebaseAuthException ex) {
//                     print('Verification failed: ${ex.message}');
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Verification failed: ${ex.message}')),
//                     );
//                   },
//                   codeSent: (String verificationId, int? resendToken) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => OtpScreen(verificationId: verificationId),
//                       ),
//                     );
//                   },
//                   codeAutoRetrievalTimeout: (String verificationId) {},
//                 );
//               },
//               child: Text("Verify Phone Number"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

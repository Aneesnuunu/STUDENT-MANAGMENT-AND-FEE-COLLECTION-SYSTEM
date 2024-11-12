import 'package:education_institution/View/screens/o3_fee.dart';
import 'package:education_institution/View/screens/fee_pending.dart';
import 'package:education_institution/View/screens/o5_old_student.dart';
import 'package:education_institution/View/screens/o2_registration.dart';
import 'package:education_institution/View/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import 'o4_student.dart';
import '../widgets/home_circle_avathar.dart';
import 'o5_close.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "ABC Tuition Center ",
        showBackButton: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
              ),
              CustomCircleAvatar(
                icon: Icons.add,
                label: "Register",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Registration(),
                      ));
                },
              ),
              SizedBox(
                width: 65,
              ),
              CustomCircleAvatar(
                icon: Icons.money_outlined,
                label: "Fee",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Fee(),
                      ));
                },
              ),
              SizedBox(
                width: 47,
              ),
              CustomCircleAvatar(
                icon: Icons.person_2_outlined,
                label: "Student",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ));
                },
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              SizedBox(
                width: 95,
              ),
              CustomCircleAvatar(
                icon: Icons.money_off_csred,
                label: "Fee Pending",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeePending(),
                      ));
                },
              ),
              SizedBox(
                width: 65,
              ),
              CustomCircleAvatar(
                icon: Icons.block,
                label: "Close",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>CloseAccount (),
                      ));
                },
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              SizedBox(
                width: 165,
              ),
              CustomCircleAvatar(
                icon: Icons.output_outlined,
                label: "Old Student",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OldStudent(),
                      ));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

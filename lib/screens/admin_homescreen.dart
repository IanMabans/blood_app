import 'package:blood_app/Reports/receive_report.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blood_app/screens/navigation_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Reports/Users Report.dart';
import '../Reports/donor status report.dart';
import '../Reports/donor_report.dart';
import '../Reports/receive status report.dart';
import 'donate_screen.dart';
import 'login_screen.dart';
import 'receive_screen.dart';

class adminHome extends StatefulWidget {
  const adminHome({Key? key}) : super(key: key);

  @override
  State<adminHome> createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  @override
  Widget build(BuildContext context) {
    //Donate Button
    final DonateButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const DonateScreen()));
        },
        child: const Text("Donate",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );

    // ReceiveButton
    final ReceiveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ReceiveScreen()));
        },
        child: const Text("Receive",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );

    final DonorReportButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const donorReport()));
        },
        child: const Text("Donor Report",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );

    final recipientReportButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const recipient()));
        },
        child: const Text("Recipient Report",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
    final usersReportButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> usersReport()));
        },
        child: const Text("Users Report",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
    final donorStatusButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const donorStatus()));
        },
        child: const Text("Donor Status Report",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
    final recipientStatusButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const receiveStatus()));
        },
        child: const Text("Recipient Status Report",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      drawer:  NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Mama Lucy Donation Admin'),
        actions:[
          Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme().apply(bodyColor: Colors.white),

            ),
            child: PopupMenuButton<int>(
                color: Colors.red,
                onSelected: (item) =>logout(context),
                itemBuilder: (context) =>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(children: [
                      Icon(Icons.logout_rounded),
                      const SizedBox(width: 8),
                      Text('Log out')]),)
                ]
            ),
          ),
        ],
        backgroundColor: Colors.red,
        actionsIconTheme: IconThemeData(
            size: 30.0,
            color: Colors.black,
            opacity: 10.0
        ),),

      body: Container(
        child: Center(
            child: ListView(
              children: [
                SizedBox(
                  height: 450.0,
                  width: double.infinity,
                  child: Carousel(
                    dotSize: 6.0,
                    dotSpacing: 15.0,
                    dotPosition: DotPosition.bottomCenter,
                    dotBgColor: Colors.transparent,
                    images: [
                      Image.asset('assets/poster1.png', fit: BoxFit.cover),
                      Image.asset('assets/poster2.png', fit: BoxFit.cover),
                      Image.asset('assets/poster3.png', fit: BoxFit.cover),

                    ],
                  ),
                ),
                const SizedBox(height: 35),
                DonateButton,
                const SizedBox(height: 35),
                ReceiveButton,
                const SizedBox(height: 35),
                DonorReportButton,
                const SizedBox(height: 35),
                donorStatusButton,
                const SizedBox(height: 35),
                recipientReportButton,
                const SizedBox(height: 35),
                recipientStatusButton,
                const SizedBox(height: 35),
                usersReportButton,
              ],
            )),
      ),

    );
  }
  // void onSelected(BuildContext context, int item){
  //   switch (item) {
  //     case 0:
  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //             (route) => false,);Fluttertoast.showToast(msg: "You have logged out 🙂" ,backgroundColor: Colors.red);
  //   }
  //
  // }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,);Fluttertoast.showToast(msg: "You have logged out 🙂" ,backgroundColor: Colors.red);
  }
}

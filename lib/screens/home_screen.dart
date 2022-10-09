import 'package:flutter/material.dart';
import 'package:blood_app/screens/navigation_drawer.dart';
import 'donate_screen.dart';
import 'receive_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Mama Lucy Donation'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 180,
                        child: Image.asset("assets/bloodlogo.png",
                            fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 35),
                      DonateButton,
                      const SizedBox(height: 35),
                      ReceiveButton
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}


import 'package:carousel_pro/carousel_pro.dart';
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
                  ReceiveButton
                ],
              )),
        ),

    );
  }
}

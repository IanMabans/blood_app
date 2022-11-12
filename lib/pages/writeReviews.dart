import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/home_screen.dart';

class writeReviews extends StatefulWidget {
  const writeReviews({Key? key}) : super(key: key);

  @override
  State<writeReviews> createState() => _writeReviewsState();
}

final _formKey = GlobalKey<FormState>();
//controllers
final fullNameEditingController = TextEditingController();
final addressEditingController = TextEditingController();
final detailsEditingController = TextEditingController();

void dispose() {
  fullNameEditingController.dispose();
  addressEditingController.dispose();
  detailsEditingController.dispose();
}

class _writeReviewsState extends State<writeReviews> {
  @override
  Widget build(BuildContext context) {
    //full name
    final fullName = TextFormField(
      autofocus: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: fullNameEditingController,
      keyboardType: TextInputType.name,
      //validator
      validator: (value) {
        RegExp regex = RegExp(r'^.{7,}$');
        if (value!.isEmpty) {
          return ("Please enter your Full Name");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Full Name(Min. 7 Character)");
        }
        return null;
      },
      onSaved: (value) {
        fullNameEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Full Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final address = TextFormField(
      autofocus: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: addressEditingController,
      keyboardType: TextInputType.streetAddress,
      //validator
      validator: (value) {
        RegExp regex = RegExp(r'^.{10,}$');
        if (value!.isEmpty) {
          return ("Please enter your Address");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Address min characters 10");
        }
        return null;
      },
      onSaved: (value) {
        addressEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.home),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    final reviewDetails = TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        controller: detailsEditingController,
        //Normal textInputField will be displayed
        maxLines: 5,
        onSaved: (value) {
          detailsEditingController.text = value!;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.rate_review),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Review",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //function to insert data on click
    Future addReview(
      String fullName,
      String address,
      String  details,
    ) async {
      await FirebaseFirestore.instance.collection("reviews").add({
        'fullName': fullName,
        'address': address,
        'reviewDetails': detailsEditingController.text,
      });
    }

    final reviewButton = Material(
      elevation: 5,
      //borderRadius: BorderRadius.circular(5),
      child: MaterialButton(
       // minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(child: CircularProgressIndicator());
                });
            addReview(
              fullNameEditingController.text.trim(),
              addressEditingController.text.trim(),
              detailsEditingController.text.trim(),
            );
            Fluttertoast.showToast(
                msg: 'Sent Review', backgroundColor: Colors.red);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else
            () {
              Fluttertoast.showToast(
                  msg: 'Unable to send review', backgroundColor: Colors.red);
            };
          fullNameEditingController.clear();
          addressEditingController.clear();
          detailsEditingController.clear();
        },
        child: const Text("Post Review",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Reviews'),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                      child:
                          Text('Kindly post a review about the application')),
                  const SizedBox(height: 35),
                  fullName,
                  const SizedBox(height: 25),
                  address,
                  const SizedBox(height: 25),
                  reviewDetails,
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        reviewButton,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

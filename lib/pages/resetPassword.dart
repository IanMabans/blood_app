import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/login_screen.dart';

class resetPassword extends StatefulWidget {
  const resetPassword({Key? key}) : super(key: key);

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

final TextEditingController emailController = TextEditingController();

class _resetPasswordState extends State<resetPassword> {
  @override
  void dispose() {
   emailController.dispose();
    super.dispose();
  }
  Future passwordReset() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginScreen()));
            Fluttertoast.showToast(msg: "Password reset email sent, check your email." ,backgroundColor: Colors.red);
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()) ,
          );
        }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // Forgot Password
    final forgotPassword= Text(
        'Enter your email to get a link to reset your password',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final resetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:passwordReset,
        child: const Text("Reset Password",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Reset Password'),
        centerTitle: true,
        actions:[
          Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme().apply(bodyColor: Colors.white),

            ),
            child: PopupMenuButton<int>(
                color: Colors.red,
                onSelected: (item) =>onSelected(context,item),
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
            Container(
                color: Colors.white,
                child: const SizedBox(height: 35)),
            forgotPassword,
            const SizedBox( height: 10),
            emailField,
            const SizedBox( height:15),
                  resetButton,
          ],
        )),
      ),
    );
  }
  void onSelected(BuildContext context, int item){
    switch (item) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,);Fluttertoast.showToast(msg: "You have logged out" ,backgroundColor: Colors.red);
    }

  }
}

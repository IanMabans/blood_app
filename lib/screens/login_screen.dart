import 'package:blood_app/screens/admin_homescreen.dart';
import 'package:blood_app/screens/home_screen.dart';
import 'package:blood_app/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//firebase
final _auth = FirebaseAuth.instance;
final _admin = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//form key
  final _formkey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  String adminEmail = 'test1@gmail.com';

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
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
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,

      //validator
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please enter your password");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //Login Button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Center(child: CircularProgressIndicator());
          signIn(emailController.text, passwordController.text, adminEmail,
              context);
          // Navigator.pushReplacement(context,
          // MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
        child: const Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: Image.asset("assets/bloodlogo.png",
                            fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 45),
                      emailField,
                      const SizedBox(height: 25),
                      passwordField,
                      const SizedBox(height: 35),
                      loginButton,
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account?"),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegistrationScreen()));
                              },
                              child: const Text("SignUp",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)))
                        ],
                      )
                    ],
                  ),
                ),
              )),
        )));
  }
}

//login function
signIn(String email, String password, String adminEmail,
    BuildContext context) async {
  if (email == ('admin@gmail.com')) {
    CircularProgressIndicator();
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
              Fluttertoast.showToast(msg: "Welcome Admin", backgroundColor: Colors.red),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const adminHome())),
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: e!.message,backgroundColor: Colors.red);
    });
  } else if (true) {
    CircularProgressIndicator();
    await _admin

        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => {
              Fluttertoast.showToast(msg: "Login Successful", backgroundColor: Colors.red),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen())),
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: e!.message,backgroundColor: Colors.red);

    });
  }
}

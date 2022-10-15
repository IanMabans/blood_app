import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({Key? key}) : super(key: key);

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  _DonateScreenState() {
    _genderVal = _gender[0];
    bloodVal = _bloodgroup[0];
  }

  //variables

  final _gender = ['Male', 'Female', 'Other'];
  String? _genderVal = "";
  String? bloodVal = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController _date = TextEditingController();

  final _bloodgroup = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
    'I dont know'
  ];

  // create Time picker method
  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }

  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);

  //editing Controller
  final fullNameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final weightEditingController = TextEditingController();
  final genderEditingController = TextEditingController();
  final bloodgroupEditingController = TextEditingController();
  final timeEditingController = TextEditingController();
  final dateEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final messageController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref();

  void dispose() {
    fullNameEditingController.dispose();
    ageEditingController.dispose();
    weightEditingController.dispose();
    genderEditingController.dispose();
    bloodgroupEditingController.dispose();
    timeEditingController.dispose();
    dateEditingController.dispose();
    emailEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Full name
    final fullName = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      controller: fullNameEditingController,

      keyboardType: TextInputType.name,
      //validator
      validator: (value) {
        RegExp regex = RegExp(r'^.{7,}$');
        if (value!.isEmpty) {
          return ("Please enter your Full Name");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Name(Min. 3 Character)");
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
        ),
      ),
    );

    //email field
    final email = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      controller: emailEditingController,
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
        emailEditingController.text = value!;
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

    //age
    final age = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: ageEditingController,
      decoration: InputDecoration(
        labelText: 'Age',
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your age';
        } else if (int.tryParse(value)! > 100) {
          return 'You are really old enter a valid age';
        } else if (int.tryParse(value)! < 16) {
          return 'You are too young to donate';
        } else {
          return null;
        }
      },
    );

    //Gender dropdown
    final gender = DropdownButtonFormField(
        value: _genderVal,
        items: _gender
            .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            _genderVal = val as String;
          });
        },
        icon: const Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: Colors.redAccent,
        ),
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          labelText: "Gender",
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //date of appointment
    final date_of_appointment = TextField(
      controller: _date,
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today_rounded),
        labelText: "Please select Appointment Date",
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () async {
        DateTime? pickdate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2050));
        if (pickdate != null) {
          setState(() {
            _date.text = DateFormat('dd/MM/yyyy').format(pickdate);
          });
        }
      },
    );

    final time = Material(
      borderRadius: BorderRadius.horizontal(),
      elevation: 1,
      child: Text(
        _timeOfDay.format(context).toString(),
        style: TextStyle(fontSize: 20),
      ),
    );
    // pick time
    final time_button = Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        onPressed: _showTimePicker,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Text(
            'Pick Time',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    //weight
    final weight = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: weightEditingController,
      decoration: InputDecoration(
        labelText: 'Weight',
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your weight';
        } else if (int.tryParse(value)! < 50) {
          return 'You weigh less to donate';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        weightEditingController.text = value!;
      },
    );

    //bloodgroup
    final bloodgroup = DropdownButtonFormField(
        value: bloodVal,
        items: _bloodgroup
            .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            bloodVal = val as String;
          });
        },
        icon: const Icon(
          Icons.bloodtype_rounded,
          color: Colors.redAccent,
        ),
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          labelText: "Blood Group",
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //function to insert data on click
    Future addDonationdetails(
      String fullName,
      int age,
      int weight,
      String email,
      String gender,
      String bloodgroup,
      String date_of_appointment,
      String time,
    ) async {
      await FirebaseFirestore.instance.collection("donate_request").add({
        'fullName': fullName,
        'age': age,
        'weight': weight,
        'gender': _genderVal,
        'bloodgroup': bloodVal,
        'date_of_appointment': _date.text,
        'email': emailEditingController.text,
        // 'time': _timeOfDay,
      });
    }

    //Book button
    final bookButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final response = await sendEmail(
                fullNameEditingController.value.text,
                emailEditingController.value.text,
                messageController.value.text,
                ageEditingController.value.text,
                weightEditingController.value.text,
                _genderVal!,
                bloodVal!,
                _date.value.text);
            addDonationdetails(
                fullNameEditingController.text.trim(),
                int.parse(ageEditingController.text.trim()),
                int.parse(weightEditingController.text.trim()),
                genderEditingController.text.trim(),
                bloodgroupEditingController.text.trim(),
                dateEditingController.text.trim(),
                emailEditingController.text.trim(),
                timeEditingController.text.trim());
            Fluttertoast.showToast(msg: 'Successfully Booked');

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
            ScaffoldMessenger.of(context).showSnackBar(response == 200
                ? const SnackBar(
                    content: Text('Booked Check your email!'),
                    backgroundColor: Colors.red)
                : const SnackBar(
                    content: Text('Failed to book!'),
                    backgroundColor: Colors.red));
            fullNameEditingController.clear();
            emailEditingController.clear();
            messageController.clear();
            ageEditingController.clear();
          }
        },
        child: const Text("Book",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Donate Screen")),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
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
                    fullName,
                    const SizedBox(height: 35),
                    email,
                    const SizedBox(height: 35),
                    age,
                    const SizedBox(
                      height: 30,
                    ),
                    weight,
                    const SizedBox(height: 35),
                    gender,
                    const SizedBox(height: 35),
                    bloodgroup,
                    const SizedBox(height: 35),
                    date_of_appointment,
                    const SizedBox(height: 35),
                    Row(
                      children: [
                        time_button,
                        const SizedBox(
                          width: 30,
                        ),
                        time,
                      ],
                    ),
                    const SizedBox(height: 35),
                    bookButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Send Email Method
Future sendEmail(
  String name,
  String email,
  String subject,
  String weight,
  String _genderVal,
  String age,
  String bloodVal,
  String date,
) async {
  final serviceId = 'service_abignuu';
  final templateId = 'template_wocn4q9';
  final userId = 'uAtaDvVi-cdzgGdQ5';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': name,
        'user_email': email,
        'user_subject': "Confirmation of Blood Donation Email",
        'user_message3': age,
        'user_message1': "Thank you for donating at Mama Lucy Hospital ",
        'user_message2': weight,
        'user_message6': _genderVal,
        'user_message4': bloodVal,
        'user_message5': date,
      },
    }),
  );

  return response.statusCode;
}

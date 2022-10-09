import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'home_screen.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  _ReceiveScreenState() {
    _selectedVal = _gender[0];
    selectedVal = _bloodgroup[0];
    reasonsVal = _reasons[0];
  }

  //variables
  final _gender = ['Male', 'Female', 'Other'];
  String? _selectedVal = "";
  String? selectedVal = "";
  String? reasonsVal = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController _date = TextEditingController();
  final _bloodgroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-', 'I dont know'];
  final _reasons = ['Accident', 'Anemia', 'Surgery', 'Friend'];

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
  final reasonsEditingController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref();

  void dispose() {
    fullNameEditingController.dispose();
    ageEditingController.dispose();
    weightEditingController.dispose();
    genderEditingController.dispose();
    bloodgroupEditingController.dispose();
    timeEditingController.dispose();
    dateEditingController.dispose();
    reasonsEditingController.dispose();
    super.dispose();
  }


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
        RegExp regex = RegExp(r'^.{3,}$');
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
        }else if (int.tryParse(value)! < 16) {
          return 'You are too young to receive ';
        }
        else {
          return null;
        }
      },
        );


    //Gender dropdown
    final gender = DropdownButtonFormField(
        value: _selectedVal,
        items: _gender
            .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            _selectedVal = val as String;
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
    final _date_of_appointment = TextFormField(
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
        }  else {
          return null;
        }
      },
      onSaved: (value) {
        weightEditingController.text = value!;
      },
    );

    //bloodgroup
    final bloodgroup = DropdownButtonFormField(
        value: selectedVal,
        items: _bloodgroup
            .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            selectedVal = val as String;
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

    //Reasons
    final reasons = DropdownButtonFormField(
        value: reasonsVal,
        items: _reasons
            .map((e) => DropdownMenuItem(
          child: Text(e),
          value: e,
        ))
            .toList(),
        onChanged: (val) {
          setState(() {
            reasonsVal = val as String;
          });
        },
        icon: const Icon(
          Icons.bloodtype_outlined,
          color: Colors.redAccent,
        ),
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          labelText: "Reasons for receiving blood",
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //Time displayed
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


    //function to insert data on click
    Future addDonationdetails(
        String fullName,
        int age,
        int weight,
        String gender,
        String bloodgroup,
        String date_of_appointment,
        String time,
        String reasons,) async {
      await FirebaseFirestore.instance.collection("receive").add({
        'fullName': fullName,
        'age': age,
        'weight': weight,
        'gender': _selectedVal,
        'bloodgroup': selectedVal,
        'date_of_appointment': _date.text,
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
        onPressed: () {
          addDonationdetails(
              fullNameEditingController.text.trim(),
              int.parse(ageEditingController.text.trim()),
              int.parse(weightEditingController.text.trim()),
              genderEditingController.text.trim(),
              bloodgroupEditingController.text.trim(),
              dateEditingController.text.trim(),
              timeEditingController.text.trim(),
              reasonsEditingController.text.trim());
          Fluttertoast.showToast(msg: 'Successfully Booked');
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>    const HomeScreen()));
        },
        child: const Text("Book",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );


    return Scaffold(
      appBar: AppBar(title: Text("Receive Screen")),
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
                    reasons,
                    const SizedBox(height: 35),
                    _date_of_appointment,
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
//method

}

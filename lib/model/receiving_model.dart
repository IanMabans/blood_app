import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection("receive request");

//variables
final _gender = ['Male', 'Female', 'Other'];
String? _genderVal = "";
String? bloodVal = "";
String? reasonsVal = "";
TextEditingController _date = TextEditingController();
final emailEditingController = TextEditingController();
class Database {
  static String? receiveUid;
}
Future<void> addDonationdetails({
  required String fullName,
  required int age,
  required int weight,
  required String email,
  required String gender,
  required String bloodgroup,
  required String date_of_appointment,
  required String time,
  required String reasons,
}) async {
  DocumentReference documentReferencer =
  _mainCollection.doc(Database.receiveUid).collection("receive request").doc();

  Map<String, dynamic> data = <String, dynamic>{
    'fullName': fullName,
    'age': age,
    'weight': weight,
    'gender': _genderVal,
    'bloodgroup': bloodVal,
    'date_of_appointment': _date.text,
    'email': emailEditingController.text,
    'reasons': reasonsVal,
    // 'time': _timeOfDay,
  };

}
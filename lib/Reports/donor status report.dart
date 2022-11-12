import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class donorStatus extends StatefulWidget {
  const donorStatus({Key? key}) : super(key: key);

  @override
  State<donorStatus> createState() => _donorStatusState();
}

class Database {
  static String? userUid;
}

var firestoreInstance = FirebaseFirestore.instance;
dynamic firebaseUser = FirebaseAuth.instance.currentUser;

class _donorStatusState extends State<donorStatus> {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('donor_status');

  late Stream<QuerySnapshot> _streamData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamData = _collectionReference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Donors Status Report'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _streamData,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: const Text('Some error occurred'),
              );
            }
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  //columnSpacing: 10,
                  //horizontalMargin: 5,
                  //minWidth:600,

                  columns: [
                    DataColumn2(
                        label: Expanded(
                      child: Text(
                        'FULL NAME',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    )),
                    DataColumn2(
                        label: Expanded(
                      child: Text(
                        'DONATED BLOOD',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    )),
                    DataColumn2(
                        label: Expanded(
                      child: Text(
                        'EMAIL',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    )),
                    DataColumn2(
                        label: Expanded(
                      child: Text(
                        'BLOOD GROUP',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    )),
                    DataColumn2(
                        label: Expanded(
                      child: Text(
                        'GENDER',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    )),
                    DataColumn2(
                        label: Expanded(
                      child: Text(
                        'DATE OF APPOINTMENT',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    )),
                    DataColumn2(
                        label: Expanded(
                      child: Text(
                        'AGE',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    )),
                    DataColumn2(
                        label: Expanded(
                      child: Text(
                        'WEIGHT',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    )),
                  ],
                  rows: snapshot.data!.docs
                      .map((DocumentSnapshot thisItem) => DataRow(cells: [
                            DataCell(Text(thisItem['fullName'])),
                            DataCell(
                              Text("${thisItem['Donor Status']}"),
                              showEditIcon: true,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('Status'),
                                          content: Text(
                                              'Has the donor donated blood?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  thisItem.reference.update({
                                                    'Donor Status': 'donated'
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text('donated')),
                                            TextButton(
                                                onPressed: () {
                                                  thisItem.reference.update({
                                                    'Donor Status':
                                                        'disqualified'
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text('disqualified')),
                                          ],
                                        ));
                              },
                            ),
                            DataCell(Text(thisItem['email'])),
                            DataCell(Text(thisItem['bloodgroup'])),
                            DataCell(Text(thisItem['gender'])),
                            DataCell(Text(thisItem['date_of_appointment'])),
                            DataCell(Text("${thisItem['age']}")),
                            DataCell(Text("${thisItem['weight']}")),
                          ]))
                      .toList(),
                ),
              );

              // return buildListView(items);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  List<Map> parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List<Map> listItems = listDocs
        .map((e) => {
              'fullName': e['fullName'],
              'Donor Status': e['Donor Status'],
              'email': e['email'],
              'bloodgroup': e['bloodgroup'],
              'gender': e['gender'],
              'date_of_appointment': e['date_of_appointment'],
              'age': e['age'],
              'weight': e['weight'],
            })
        .toList();
    return listItems;
  }
}

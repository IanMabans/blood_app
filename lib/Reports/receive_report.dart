import 'package:blood_app/Reports/recipient_details.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class recipient extends StatefulWidget {
  const recipient({Key? key}) : super(key: key);

  @override
  State<recipient> createState() => _recipientState();
}

class _recipientState extends State<recipient> {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('receive request');

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
          title: Text('Recipient Booking Report'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _streamData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: const Text('Some error occurred'),
              );
            }
            if (snapshot.hasData) {
              List<Map> items = parseData(snapshot.data);
              return buildListView(items);
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
              'email': e['email'],
              'bloodgroup': e['bloodgroup'],
              'gender': e['gender'],
              'date_of_appointment': e['date_of_appointment'],
              'age': e['age'],
              'weight': e['weight'],
              'reasons': e['reasons']
            })
        .toList();
    return listItems;
  }

  ListView buildListView(List<Map<dynamic, dynamic>> _list) {
    return ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          Map thisItem = _list[index];
          return ListView.builder(
              shrinkWrap: true,
              itemCount: _list.length,
              itemBuilder: (context, index) {
                Map thisItem = _list[index];
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: Column(
                      children: [
                        DataTable(
                            //columnSpacing: 10,
                            //   horizontalMargin: 5,
                            //minWidth:600,

                            columns: [
                              DataColumn2(
                                  label: Expanded(
                                child: Text(
                                  'Full Name',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red),
                                ),
                              )),
                              DataColumn2(
                                  label: Expanded(
                                child: Text(
                                  'EMAIL',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red),
                                ),
                              )),
                              DataColumn2(
                                  label: Expanded(
                                child: Text(
                                  'BLOOD GROUP',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red),
                                ),
                              )),
                              DataColumn2(
                                  label: Expanded(
                                child: Text(
                                  'GENDER',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red),
                                ),
                              )),
                              DataColumn2(
                                  label: Expanded(
                                child: Text(
                                  'DATE OF APPOINTMENT',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red),
                                ),
                              )),
                              DataColumn2(
                                  label: Expanded(
                                child: Text(
                                  'AGE',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red),
                                ),
                              )),
                              DataColumn2(
                                  label: Expanded(
                                child: Text(
                                  'WEIGHT',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red),
                                ),
                              )),
                              DataColumn2(
                                  label: Expanded(
                                child: Text(
                                  'REASONS',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red),
                                ),
                              )),
                            ], rows: [
                          DataRow(cells: [
                            DataCell(Text(thisItem['fullName'])),
                            DataCell(Text(thisItem['email'])),
                            DataCell(Text(thisItem['bloodgroup'])),
                            DataCell(Text(thisItem['gender'])),
                            DataCell(Text(thisItem['date_of_appointment'])),
                            DataCell(Text("${thisItem['age']}")),
                            DataCell(Text("${thisItem['weight']}")),
                            DataCell(Text(thisItem['reasons'])),
                          ])
                        ])
                      ],
                    ),
                  ),
                );
                // return ListTile(
                //   leading: Icon(
                //     Icons.person_sharp,
                //     color: Colors.redAccent,
                //   ),
                //   title: Text(thisItem['fullName']),
                //   subtitle: Text(thisItem['email']),
                //   trailing: Text(thisItem['bloodgroup']),
                //   isThreeLine: true,
                //   dense: true,
                //   onTap: () {
                //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                //         builder: (context) => const recipientDetails()));
                //   },
                // );
              });
        });
  }
}

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class usersReport extends StatefulWidget {
  usersReport({Key? key}) : super(key: key);

  @override
  State<usersReport> createState() => _usersReportState();
}

class _usersReportState extends State<usersReport> {
  CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('users');

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
          title: Text('Registered Users Report'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _streamData,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              'FIRST NAME',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, color: Colors
                                  .red),
                            ),
                          )),
                      DataColumn2(label: Expanded(
                        child: Text(
                          'SECOND_NAME',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.red),
                        ),
                      )),
                      DataColumn2(
                          label: Expanded(
                            child: Text(
                              'EMAIL',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, color: Colors
                                  .red),
                            ),
                          )),
                      DataColumn2(
                          label: Expanded(
                            child: Text(
                              'UID',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, color: Colors
                                  .red),
                            ),
                          )),
                    ],
                    rows: snapshot.data!.docs
                      .map((DocumentSnapshot thisItem) =>
                      DataRow(cells: [
                        DataCell(Text(thisItem['firstName'])),
                        DataCell(Text(thisItem['secondName'])),
                        DataCell(Text(thisItem['email'])),
                        DataCell(Text(thisItem['uid'])),
                      ]))
                      .toList(),
                  ),
              );
              }
                  return Center(
                  child: CircularProgressIndicator(),);
          },
        ));
  }

  List<Map> parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List<Map> listItems = listDocs
        .map((e) =>
    {
      'firstName': e['firstName'],
      'secondName': e['secondName'],
      'email': e['email'],
      'uid': e['uid'],

    })
        .toList();
    return listItems;
  }

}

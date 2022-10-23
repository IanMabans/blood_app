import 'package:blood_app/Reports/recipient_reasons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class recipientDetails extends StatefulWidget {
  const recipientDetails({Key? key}) : super(key: key);

  @override
  State<recipientDetails> createState() => _recipientDetailsState();
}

class _recipientDetailsState extends State<recipientDetails> {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('receive request');
  late Stream<QuerySnapshot> _streamData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _streamData = _collectionReference.snapshots();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recipient Booked Date Report'),
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
              'date_of_appointment': e['date_of_appointment'],
              'bloodgroup': e['bloodgroup'],
            })
        .toList();
    return listItems;
  }

  ListView buildListView(List<Map<dynamic, dynamic>> _list) {
    return ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          Map thisItem = _list[index];
          return ListTile(
            leading: Icon(
              Icons.person_sharp,
              color: Colors.redAccent,
            ),
            title: Text(thisItem['fullName']),
            subtitle: Text(thisItem['date_of_appointment']),
            trailing: Text(thisItem['bloodgroup']),
            isThreeLine: true,
            dense: true,
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const recipientReasons()));
            },
          );
        });
  }
}

import 'package:blood_app/Reports/recipient_gender.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class recipientReasons extends StatefulWidget {
  const recipientReasons({Key? key}) : super(key: key);

  @override
  State<recipientReasons> createState() => _recipientReasonsState();
}

class _recipientReasonsState extends State<recipientReasons> {
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
          title: Text('Recipient Reasons Report'),
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
              'reasons': e['reasons'],
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
            subtitle: Text(thisItem['reasons']),
            trailing: Text(thisItem['bloodgroup']),
            isThreeLine: true,
            dense: true,
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const recipientGender()));
            },
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class donorGender extends StatefulWidget {
  const donorGender({Key? key}) : super(key: key);

  @override
  State<donorGender> createState() => _donorGenderState();
}

class _donorGenderState extends State<donorGender> {
  CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('donor request');
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
          title: Text('Donor Booked Gender Report'),
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
      'gender': e['gender'],
      'bloodgroup': e ['bloodgroup'],
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
            subtitle: Text(thisItem['gender']),
            trailing: Text(thisItem['bloodgroup']),
            isThreeLine: true,
            dense: true,
            // onTap: () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (context) => const donorDetails()));
            // },
          );
        });
  }
}

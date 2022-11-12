
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class reviews extends StatefulWidget {
  const reviews({Key? key}) : super(key: key);

  @override
  State<reviews> createState() => _reviewsState();
}

class _reviewsState extends State<reviews> {
  CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('reviews');
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
          title: Text('Reviews'),
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
      'reviewDetails': e['reviewDetails'],
    })
        .toList();
    return listItems;
  }

  ListView buildListView(List<Map<dynamic, dynamic>> _list) {
    return ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          Map thisItem = _list[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: Icon(
                Icons.person_sharp,
                color: Colors.redAccent,
              ),
              title: Text(thisItem['fullName']),
              subtitle: Text(thisItem['reviewDetails']),
              isThreeLine: true,
              dense: true,

            ),
          );
        });
  }
}

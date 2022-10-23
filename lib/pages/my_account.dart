import 'package:flutter/material.dart';
class myAccount extends StatefulWidget {
  const myAccount({Key? key}) : super(key: key);

  @override
  State<myAccount> createState() => _myAccountState();
}

class _myAccountState extends State<myAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        centerTitle: true,
      ),
    );
  }
}

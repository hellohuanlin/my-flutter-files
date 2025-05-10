

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DummyTestingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DummyTestingPageState();
}

class _DummyTestingPageState extends State<DummyTestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dummy Testing Page')),
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (BuildContext context, int index) {
          return Text('item');
        },
      ),
    );
  }
}
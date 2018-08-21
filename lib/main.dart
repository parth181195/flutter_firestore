import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<DocumentSnapshot> subcription;
  DocumentReference docRef =
      Firestore.instance.collection('path').document('data');
  dynamic data;
  @override
  initState() {
    super.initState();
    subcription = docRef.snapshots().listen((dataSnapShot) {
      if (dataSnapShot.exists) {
        setState(() {
          data = dataSnapShot.data;
          print(data);
        });
      } else {
        setState(() {
          data = null;
        });
      }
    });
  }

  void _addData() {
    docRef.setData({'name': 'parth'}).whenComplete(() {
      print('data added');
    }).catchError((e) => print(e));
  }

  void _updateData() {
    docRef.updateData({'name': 'parth is cool'}).whenComplete(() {
      print('data Updated');
    }).catchError((e) => print(e));
  }

  void _deleteData() {
    docRef.delete().whenComplete(() {
      print('data Deleted');
      setState(() {});
    }).catchError((e) => print(e));
  }

  void _fetchData() {
    docRef.get().then((dataSnapShot) {
      if (dataSnapShot.exists) {
        setState(() {
          data = dataSnapShot.data;
          print(data);
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              color: Colors.blue,
              child: Text('Add'),
              onPressed: _addData,
            ),
            Padding(
              padding: new EdgeInsets.all(10.0),
            ),
            CupertinoButton(
              color: Colors.green,
              child: Text('Update'),
              onPressed: _updateData,
            ),
            Padding(
              padding: new EdgeInsets.all(10.0),
            ),
            CupertinoButton(
              color: Colors.red,
              child: Text('Delete'),
              onPressed: _deleteData,
            ),
            Padding(
              padding: new EdgeInsets.all(10.0),
            ),
            CupertinoButton(
              color: Colors.purple,
              child: Text('Fetch'),
              onPressed: _fetchData,
            ),
            Padding(
              padding: new EdgeInsets.all(10.0),
            ),
            data == null ? new Container() : new Text(data.toString())
          ],
        ),
      ),
    );
  }
}

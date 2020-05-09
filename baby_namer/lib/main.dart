import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

//final dummySnapshot = [
//  {"name": "Filip", "votes": 15},
//  {"name": "Abraham", "votes": 14},
//  {"name": "Richard", "votes": 11},
//  {"name": "Ike", "votes": 10},
//  {"name": "Justin", "votes": 1},
//];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _controller = TextEditingController();
  Future<void> addName() async {
    _controller.clear();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a baby name'),
          content: SingleChildScrollView(
            child: TextField(controller: _controller,),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ADD'),
              onPressed: () {
                // add to firebase
                //print(_controller.text);
                var data = {
                  'name':_controller.text,
                  'votes':0,
                  'dislike':0,
                };

                Firestore.instance.collection('baby').add(data);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baby Name Votes')),
      body: _buildBody(context),
      //floatingActionButtonLocation: FloatingActionButtonLocation,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addName();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Firestore.instance.collection('baby').document(data.documentID).delete();
            },
          ),
          title: Text(record.name),
          trailing: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.thumb_up),
                        onPressed: () => record.reference.updateData({'votes': FieldValue.increment(1)}),
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    Expanded(child: Text(record.votes.toString())),
                  ],
                ),
                SizedBox(width: 8.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.thumb_down),
                        onPressed: () => record.reference.updateData({'dislike': FieldValue.increment(1)}),
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    Expanded(child: Text(record.dislike.toString())),
                  ],
                ),
              ],
            ),
          ),
          //onTap: () => record.reference.updateData({'votes': FieldValue.increment(1)})

        ),
      ),
    );
  }
}

class Record {
  final String name;
  final int votes;
  final int dislike;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        assert(map['dislike'] != null),
        name = map['name'],
        votes = map['votes'],
        dislike = map['dislike'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes:$dislike>";
}
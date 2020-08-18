import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorize/app/home/training/question.dart';

final instance = Firestore.instance;

class QuizPage extends StatefulWidget {
  QuizPage(
      {@required this.collectionId,
      @required this.userUid,
      @required this.collectionName});

  final String collectionId;
  final String collectionName;
  final String userUid;

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.collectionName),
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: instance
          .collection('users')
          .document(widget.userUid)
          .collection('collections')
          .document(widget.collectionId)
          .collection('pairs')
          .getDocuments(),
      builder: (context, snapshot) {
        // print(snapshot.data.documents);
        if (snapshot.hasData) {
          final List<Map<String, dynamic>> trainingList =
              new List(snapshot.data.documents.length);

          for (int i = 0; i < snapshot.data.documents.length; i++) {
            trainingList[i] = {
              "vice": Pairs.fromSnapshot(snapshot.data.documents[i]).vice,
              "versa": Pairs.fromSnapshot(snapshot.data.documents[i]).versa,
              "enterNextRound": true,
              "totalHit":
                  Pairs.fromSnapshot(snapshot.data.documents[i]).totalHit,
              "id": snapshot.data.documents[i].documentID,
            };
          }

          return Question(
            snapshot: trainingList,
            collectionId: widget.collectionId,
            collectionName: widget.collectionName,
            userUid: widget.userUid,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class Pairs {
  final String vice;
  final String versa;
  final int totalHit;
  final DocumentReference reference;

  Pairs.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['vice'] != null),
        assert(map['versa'] != null),
        assert(map['totalHit'] != null),
        vice = map['vice'],
        totalHit = map['totalHit'],
        versa = map['versa'];

  Pairs.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Pairs<$vice:$versa>";
}

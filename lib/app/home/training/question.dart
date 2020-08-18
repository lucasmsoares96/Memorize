import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Color> _colorChoice = [
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
];

class Question extends StatefulWidget {
  Question(
      {@required this.snapshot,
      @required this.collectionId,
      @required this.userUid,
      @required this.collectionName});

  final List<Map<String, dynamic>> snapshot;
  final String collectionId;
  final String collectionName;
  final String userUid;

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  int wordIndex = 0;
  final _random = new Random();
  final instance = Firestore.instance;

  StreamController<List<Color>> _controller = StreamController.broadcast();
  List<Map<String, dynamic>> trainingList = [];
  Map<String, dynamic> pairsAttributes = {};

  bool miss = false;
  bool firstRound = true;
  String trainingDirection = "forward";

  List<Map<String, dynamic>> fillList(List<Map<String, dynamic>> list) {
    List<Map<String, dynamic>> tempList = [];
    list.forEach(
      (element) {
        if (element["totalHit"] < 10) {
          tempList.add(element);
        }
      },
    );
    return tempList;
  }

  @override
  void initState() {
    super.initState();

    _controller = StreamController.broadcast();
    trainingList = [];
    pairsAttributes = {};

    miss = false;
    firstRound = true;
    trainingDirection = "forward";

    _colorChoice = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pairsAttributes["userUid"] = widget.userUid;
    pairsAttributes["collectionId"] = widget.collectionId;
    print(">>> trainingList 1");
    print(trainingList);
    if (trainingList.length == 0) {
      trainingList = fillList(widget.snapshot);
      if (trainingList.length == 0) {
        _controller.close();
        trainingDirection = "forward";
        //estudar esse comando
        WidgetsBinding.instance
            .addPostFrameCallback((_) => Navigator.of(context).pop());
        // return CircularProgressIndicator();
      }
    }
    print(">>> trainingList 2");
    print(trainingList);

    print(">>> wordIndex 1");
    print(wordIndex);

    print(">>> firstRound 1");
    print(firstRound);

    if (wordIndex == trainingList.length) {
      wordIndex = 0;
      firstRound = false;
    }

    print(">>> wordIndex 2");
    print(wordIndex);

    print(">>> firstRound 2");
    print(firstRound);

    print("trainingList[wordIndex]");
    print(trainingList[wordIndex]);

    print(">>> trainingList 3");
    print(trainingList);
    if (wordIndex == 0) {
      List<Map<String, dynamic>> tempList = [];
      trainingList.forEach(
        (element) {
          print(">>> element[\"enterNextRound\"]");
          print(element["enterNextRound"]);
          if (element["enterNextRound"] == true) {
            element["enterNextRound"] = false;
            tempList.add(element);
          }
        },
      );
      trainingList.clear();
      print(">>> tempList");
      print(tempList);

      if (tempList.length == 0) {
        if (trainingDirection == "forward") {
          trainingDirection = "backward";
          trainingList = fillList(widget.snapshot);
          firstRound = true;
        } else {
          _controller.close();
          trainingDirection = "forward";
          //estudar esse comando
          WidgetsBinding.instance
              .addPostFrameCallback((_) => Navigator.of(context).pop());
          // return CircularProgressIndicator();
        }
      } else {
        trainingList.addAll(tempList);
        trainingList.shuffle();
        // trainingList.forEach(
        //   (element) {
        //     print("vice " +
        //         element["vice"].toString() +
        //         " " +
        //         element["enterNextRound"].toString());
        //   },
        // );
      }
    }
    print(">>> trainingDirection");
    print(trainingDirection);

    print(">>> trainingList 4");
    print(trainingList);

    final word = trainingList[wordIndex];

    final List<Map<String, dynamic>> alternatives = new List(5);

    alternatives[0] = word;
    int i;
    int j;
    bool equal = false;

    for (i = 1; i < 5; i++) {
      equal = false;
      final _maybe = widget.snapshot[_random.nextInt(widget.snapshot.length)];
      for (j = 0; j < i; j++) {
        if (alternatives[j]["vice"] == _maybe["vice"]) {
          equal = true;
        }
      }
      if (equal == true) {
        i--;
      } else {
        alternatives[i] = _maybe;
      }
    }

    alternatives.shuffle();

    return Column(
      children: <Widget>[
        Expanded(
          child: Align(
            child: trainingDirection == "forward"
                ? Text(
                    word["versa"],
                    style: TextStyle(fontSize: 24),
                  )
                : Text(
                    word["vice"],
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ),
        Container(
          height: 400,
          child: ListView.builder(
            itemCount: alternatives.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, alternatives[index], word, index,
                  trainingList.length);
            },
            padding: const EdgeInsets.only(top: 20.0),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(
    BuildContext context,
    Map<String, dynamic> data,
    Map<String, dynamic> right,
    int index,
    int length,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () async {
          await _answer(data, right, index, length);
        },
        child: StreamBuilder<List<Color>>(
          initialData: [
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
          ],
          stream: _controller.stream,
          builder: (context, snapshot) {
            return Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: snapshot.data[index],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: trainingDirection == "forward"
                  ? Text(data["vice"])
                  : Text(data["versa"]),
            );
          },
        ),
      ),
    );
  }

  Future<void> _answer(Map<String, dynamic> pairs, Map<String, dynamic> right,
      int index, int length) async {
    if (pairs["vice"] == right["vice"]) {
      if (miss == false && firstRound == true) {
        right["enterNextRound"] = false;
        await instance
            .collection('users')
            .document(pairsAttributes["userUid"])
            .collection('collections')
            .document(pairsAttributes["collectionId"])
            .collection("pairs")
            .document(right["id"])
            .updateData(
          {
            "totalHit": right["totalHit"] + 1,
          },
        );
      } else if (miss == false) {
        right["enterNextRound"] = false;
      } else if (miss == true) {
        right["enterNextRound"] = true;
        miss = false;
        await instance
            .collection('users')
            .document(pairsAttributes["userUid"])
            .collection('collections')
            .document(pairsAttributes["collectionId"])
            .collection("pairs")
            .document(right["id"])
            .updateData(
          {
            "totalHit": 0,
          },
        );
      }
      _colorChoice[index] = Colors.green;
      _controller.sink.add(_colorChoice);
      Timer(
        Duration(milliseconds: 500),
        () {
          setState(
            () {
              _colorChoice[0] = Colors.white;
              _colorChoice[1] = Colors.white;
              _colorChoice[2] = Colors.white;
              _colorChoice[3] = Colors.white;
              _colorChoice[4] = Colors.white;
              wordIndex = wordIndex + 1;
            },
          );
        },
      );
    } else {
      miss = true;
      _colorChoice[index] = Colors.red;
      _controller.sink.add(_colorChoice);
    }
    print(">>> miss");
    print(miss);
  }
}

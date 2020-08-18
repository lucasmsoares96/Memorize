import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final instance = Firestore.instance;

class PairsPage extends StatelessWidget {
  PairsPage(
      {@required this.collectionId,
      @required this.userUid,
      @required this.collectionName});

  final String collectionId;
  final String collectionName;
  final String userUid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(collectionName),
          actions: [
            FlatButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => _showDialog(context),
            )
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final TextEditingController _vice = TextEditingController();
    final TextEditingController _versa = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nome da coleção"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: <Widget>[
                  // Expanded(
                  //   flex: 1,
                  //   child: Text('vice: '),
                  // ),
                  Expanded(
                    // flex: 2,
                    child: TextFormField(
                      controller: _vice,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  // Expanded(
                  //   flex: 1,
                  //   child: Text('versa: '),
                  // ),
                  Expanded(
                    // flex: 2,
                    child: TextFormField(
                      controller: _versa,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Salvar"),
              onPressed: () async {
                // final list1 = [
                //   {"vice": "accomplish", "versa": "realizar", "totalHit": 0},
                //   {"vice": "actually", "versa": "na realidade", "totalHit": 0},
                //   {"vice": "Against", "versa": "contra", "totalHit": 0},
                //   {"vice": "almost", "versa": "quase", "totalHit": 0},
                //   {"vice": "also", "versa": "além disso", "totalHit": 0},
                //   {"vice": "Angular brackets", "versa": "<>", "totalHit": 0},
                //   {"vice": "arranged", "versa": "organizado", "totalHit": 0},
                //   {
                //     "vice": "as well",
                //     "versa": "também no fim da frase",
                //     "totalHit": 0
                //   },
                //   {"vice": "attaches", "versa": "atribui", "totalHit": 0},
                //   {"vice": "avoid", "versa": "evitar", "totalHit": 0},
                //   {"vice": "aware", "versa": "ciente", "totalHit": 0},
                //   {
                //     "vice": "bear in me",
                //     "versa": "confiar em mim",
                //     "totalHit": 0
                //   },
                //   {
                //     "vice": "beforehand",
                //     "versa": "antecipadamente",
                //     "totalHit": 0
                //   },
                //   {"vice": "Belongs", "versa": "pertence", "totalHit": 0},
                //   {"vice": "beyond", "versa": "além", "totalHit": 0},
                //   {
                //     "vice": "boilerplate code",
                //     "versa": "código clichê",
                //     "totalHit": 0
                //   },
                //   {
                //     "vice": "break them up",
                //     "versa": "acabar com eles",
                //     "totalHit": 0
                //   },
                //   {"vice": "brief", "versa": "breve", "totalHit": 0},
                //   {"vice": "broad", "versa": "amplo", "totalHit": 0},
                //   {"vice": "By the way", "versa": "a propósito", "totalHit": 0},
                //   {"vice": "carried over", "versa": "carregado", "totalHit": 0},
                //   {"vice": "carry on", "versa": "continuar", "totalHit": 0},
                //   {"vice": "citizens", "versa": "cidadãos", "totalHit": 0},
                //   {"vice": "clarified", "versa": "esclarecido", "totalHit": 0},
                //   {
                //     "vice": "Closure",
                //     "versa": "função anônima, fechamento",
                //     "totalHit": 0
                //   },
                //   {"vice": "Comma", "versa": "virgula", "totalHit": 0},
                //   {"vice": "composed", "versa": "composto", "totalHit": 0},
                //   {"vice": "Confident", "versa": "confiante", "totalHit": 0},
                //   {"vice": "constraint", "versa": "limitação", "totalHit": 0},
                //   {"vice": "Couple", "versa": "par, alguns", "totalHit": 0},
                //   {"vice": "Coupling", "versa": "acoplamento", "totalHit": 0},
                //   {"vice": "cover", "versa": "cobrir", "totalHit": 0},
                //   {"vice": "curly braces", "versa": "chaves", "totalHit": 0},
                //   {"vice": "decoupled", "versa": "desacoplado", "totalHit": 0},
                //   {"vice": "deserves", "versa": "merece", "totalHit": 0},
                //   {"vice": "Diversion", "versa": "desvio", "totalHit": 0},
                //   {"vice": "Draw", "versa": "atrair", "totalHit": 0},
                //   {"vice": "drawbacks", "versa": "desvantagens", "totalHit": 0},
                //   {"vice": "earlier", "versa": "mais cedo", "totalHit": 0},
                //   {"vice": "enough", "versa": "suficiente", "totalHit": 0},
                //   {"vice": "ensure", "versa": "garantir", "totalHit": 0},
                //   {"vice": "Even", "versa": "par", "totalHit": 0},
                //   {"vice": "even though", "versa": "Apesar de", "totalHit": 0},
                //   {"vice": "evenly", "versa": "uniformemente", "totalHit": 0},
                //   {"vice": "figure out", "versa": "descobrir", "totalHit": 0},
                //   {"vice": "further", "versa": "mais longe", "totalHit": 0},
                //   {"vice": "Goal", "versa": "objetivo", "totalHit": 0},
                //   {"vice": "Guard", "versa": "proteger", "totalHit": 0},
                //   {"vice": "guest", "versa": "convidado", "totalHit": 0},
                //   {"vice": "guidelines", "versa": "orientações", "totalHit": 0},
                // ];
                // list1.forEach(
                //   (element) async {
                //     await instance
                //         .collection('users')
                //         .document(userUid)
                //         .collection('collections')
                //         .document(collectionId)
                //         .collection('pairs')
                //         .document()
                //         .setData(element);
                //   },
                // );

                await instance
                    .collection('users')
                    .document(userUid)
                    .collection('collections')
                    .document(collectionId)
                    .collection('pairs')
                    .document()
                    .setData(
                  {
                    "vice": _vice.text,
                    "versa": _versa.text,
                    "totalHit": 0,
                  },
                );

                // QuerySnapshot listPairs = await instance
                //     .collection('users')
                //     .document(userUid)
                //     .collection('collections')
                //     .document(collectionId)
                //     .collection("pairs")
                //     .getDocuments();
                // listPairs.documents.forEach((element) async {
                //   await instance
                //       .collection('users')
                //       .document(userUid)
                //       .collection('collections')
                //       .document(collectionId)
                //       .collection("pairs")
                //       .document(element.documentID)
                //       .updateData({"totalHit": 5});
                // });
                // Navigator.of(context).pop();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: instance
          .collection('users')
          .document(userUid)
          .collection('collections')
          .document(collectionId)
          .collection('pairs')
          .orderBy("vice")
          .snapshots(),
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
    final pairs = Pairs.fromSnapshot(data);

    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      onDismissed: (direction) async {
        await instance
            .collection('users')
            .document(userUid)
            .collection('collections')
            .document(collectionId)
            .collection('pairs')
            .document(data.documentID)
            .delete();
      },
      background: Container(
        padding: EdgeInsets.only(right: 16),
        alignment: Alignment(1, 0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Padding(
        key: ValueKey(pairs.vice),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: pairs.totalHit < 10 ? Colors.white : Colors.green,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(pairs.vice),
            trailing: Text(pairs.versa),
            onTap: () {},
          ),
        ),
      ),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorize/app/home/colections/pairs_page.dart';
import 'package:memorize/services/auth.dart';
import 'package:provider/provider.dart';

final instance = Firestore.instance;

class CollectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return FutureBuilder(
      future: auth.currentUser(),
      builder: (context, user) {
        if (user.hasData) {
          return CupertinoTabView(
            builder: (contex) => SafeArea(
              top: false,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Coleções'),
                  actions: [
                    FlatButton(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () => _showDialog(contex, user.data),
                    )
                  ],
                ),
                body: _buildBody(context, user.data),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _showDialog(BuildContext context, User user) {
    final TextEditingController _collectionName = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nome da coleção"),
          content: TextFormField(
            controller: _collectionName,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Salvar"),
              onPressed: () {
                instance
                    .collection('users')
                    .document(user.uid)
                    .collection('collections')
                    .document()
                    .setData({
                  "name": _collectionName.text,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, User user) {
    return StreamBuilder<QuerySnapshot>(
      stream: instance
          .collection('users')
          .document(user.uid)
          .collection('collections')
          .orderBy("name")
          .snapshots(),
      builder: (context, query) {
        if (!query.hasData) return LinearProgressIndicator();
        return _buildList(context, query.data.documents, user);
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot, User user) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildListItem(context, data, user)).toList(),
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, User user) {
    final collections = Collections.fromSnapshot(data);

    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      onDismissed: (direction) async {
        QuerySnapshot listPairs = await instance
            .collection('users')
            .document(user.uid)
            .collection('collections')
            .document(data.documentID)
            .collection("pairs")
            .getDocuments();
        listPairs.documents.forEach((element) async {
          await instance
              .collection('users')
              .document(user.uid)
              .collection('collections')
              .document(data.documentID)
              .collection("pairs")
              .document(element.documentID)
              .delete()
              .then((value) => print(">>> deletando pares"))
              .catchError(
            (e) {
              print(e);
            },
          );
        });
        await instance
            .collection('users')
            .document(user.uid)
            .collection('collections')
            .document(data.documentID)
            .delete()
            .then((value) => print(">>> deletando coleções"))
            .catchError((e) {
          print(e);
        });
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
        key: ValueKey(collections.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(collections.name),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PairsPage(
                    collectionId: data.documentID,
                    collectionName: collections.name,
                    userUid: user.uid,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Collections {
  final String name;
  final DocumentReference reference;

  Collections.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  Collections.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Collections<$name>";
}

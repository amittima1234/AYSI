import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Lists extends StatefulWidget {
  const Lists({super.key, required this.title});
  final String title;

  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> lists = [];

  @override
  void initState() {
    super.initState();
    fetchDocumentNames();
  }

  void fetchDocumentNames() async {
    QuerySnapshot querySnapshot = await firestore.collection('lists').get();
    setState(() {
      lists =
          querySnapshot.docs.map((doc) => doc['list_name'] as String).toList();
    });
  }

  void addItemToDB(String listName) {
    firestore.collection('lists').add({
      'list_name': listName,
    }).then((DocumentReference doc) {
      print('DocumentSnapshot added with ID: ${doc.id}');
    }).catchError((error) {
      print('Error adding document: $error');
    });
    print(lists);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: _buildList()),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _addItem(),
      //   tooltip: 'Add a TextField',
      //   child: const Icon(Icons.edit),
      // ),
    );
  }

  List<Widget> _buildList() {
    List<Widget> textWidgets = [];
    for (var list in lists) {
      textWidgets.add(Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(list),
        ),
      ));
    }
    textWidgets.add(Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Add New Item',
          ),
          onFieldSubmitted: (text) async =>
              {addItemToDB(text), fetchDocumentNames()},
        ),
      ),
    ));
    return textWidgets;
  }
}

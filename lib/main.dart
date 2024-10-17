import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aysi List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ItemsList(title: 'Aysi List'),
    );
  }
}

class ItemsList extends StatefulWidget {
  const ItemsList({super.key, required this.title});

  final String title;
  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<TextFormField> lists = [];

  void _addItem() {
    setState(() {
      lists.add(
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Add New Item',
          ),
          onFieldSubmitted: (text) async => {
            addItemToDB(text)
          },
        ),
      );
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
              child: Column(children: _buildList()))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(),
        tooltip: 'Add a TextField',
        child: const Icon(Icons.edit),
      ),
    );
  }

  List<Widget> _buildList() {
    List<Widget> textWidgets = [];
    for (var list in lists) {
      textWidgets.add(Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: list,
        ),
      ));
    }
    return textWidgets;
  }
}

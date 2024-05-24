import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ItemsList(title: 'Flutter Demo Home Page'),
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
  List<TextFormField> items = [];
  void _addItem() {
    setState(() {
      items.add(
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Add New Item',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(child: Column(children: _buildList())),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(),
        tooltip: 'Add a TextField',
        child: const Icon(Icons.edit),
      ),
    );
  }

  List<Widget> _buildList() {
    List<Widget> textWidgets = [];
    for (var item in items) {
      textWidgets.add(
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: item,
        ),
      );
    }
    return textWidgets;
  }
}

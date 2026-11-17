import 'package:flutter/material.dart';
import 'package:steps_app/screen/detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title, style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Text('History'),
          IconButton.filled(
            onPressed:(){
            Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailScreen()));
            } ,
          icon: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

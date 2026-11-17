import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final focusNode = FocusNode();
  
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('保存画面', style: TextStyle(color: Colors.white)),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('メモ',style: TextStyle(fontSize: 20,color: Color.fromRGBO(70, 75, 70, 1))),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              ElevatedButton(
                onPressed: null,
                child: Text('保存する'))
            ],
          ),
        ),
      ),
    );
  }
}
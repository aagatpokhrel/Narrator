import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:dummy/widgets/expandable_fab.dart';
import 'package:dummy/widgets/paragraph_text.dart';
import 'input_screen.dart';
import 'feed_screen.dart';
import 'content_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Narrator',
        ),
        elevation: 0,
      ),
      drawer: const Drawer(
        child: Text('Welcome To Options') ,
        ),
      backgroundColor: const Color(0xff7C7B9B), //
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration:const BoxDecoration(
                  color: Colors.white,
                ),
              child:Feed() 
           ),
          )
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 80.0,
        children: [
          ActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const InputScreen(isEdit: false,)
              ),
            ),
            icon: const Icon(Icons.text_fields_outlined),
          ),
          ActionButton(
            onPressed: () async{
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['txt'],
                );
          
                if (result != null) {
                  File file = File(result.files.single.path.toString());
                  final fileName = result.files.first.name.split('.')[0];
                  final fileContents = file.readAsStringSync();

                  final paragraphText = ParagraphText(fileName, fileContents.toString());
                  paragraphText.addToAll();
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=> ShowContent(paragraphText: paragraphText))); 

                } else {
                    return;
                }
            },
            icon: const Icon(Icons.upload_file),
            ),
        ],
      ),
    );
  }
}
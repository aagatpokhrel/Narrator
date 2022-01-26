import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:floating_search_bar/floating_search_bar.dart';

import 'package:responsive_scaffold/responsive_scaffold.dart';
import 'package:dummy/widgets/expandable_fab.dart';
import 'package:dummy/widgets/paragraph_text.dart';
import 'input_screen.dart';
import 'feed_screen.dart';
import 'content_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({Key? key, required this.userId}): super(key:key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    getTextData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Narrator',
      //   ),
      //   elevation: 0,
      // ),
      // detailBuilder: (BuildContext context, int index, bool tablet){
      //   ShowContent(paragraphText: ,),
      // },
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
              CupertinoPageRoute(
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
                  paragraphText.addToAll(1);
                  Navigator.push(context, 
                  CupertinoPageRoute(builder: (context)=> ShowContent(paragraphText: paragraphText))); 

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
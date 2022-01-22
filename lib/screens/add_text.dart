import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dummy/widgets/paragraph_text.dart';
import 'show_text.dart';
import 'package:http/http.dart' as http;

class AddTextScreen extends StatefulWidget {
  const AddTextScreen({ Key? key }) : super(key: key);

  @override
  _AddTextScreenState createState() => _AddTextScreenState();
}

class _AddTextScreenState extends State<AddTextScreen> {

  late String title;
  late String content;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('Input Text'),
       ),
       body:
       Column(
        
        children: [
          const SizedBox(height:20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed:(){
                  final paragraphText = ParagraphText(title, content);
                  paragraphText.addToAll();
                  const url = 'http://127.0.0.1:5000/add_data';
                  final response = http.post(url, body: json.encode({
                    'content':paragraphText.title,
                    'title':paragraphText.content})
                  );
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> ShowText(paragraphText: paragraphText))
                  );
                },
                child: const Text(
                  'Save',
                  
                )
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: const Text(
                  'Cancel',
                )
              )
            ],
          ),
          const SizedBox(height: 40,),
          TextField(
            decoration: const InputDecoration(  
                border: OutlineInputBorder(),  
                hintText: 'Enter the Title',  
            ),  
            onChanged: (text){
              setState(() {
                title = text;
              });
            }
          ),
          const SizedBox(height: 10,),
          TextFormField(
              minLines: 8,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                alignLabelWithHint: true,
                hintText: 'Write Your Own Article/Story',
                labelStyle: TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (textchange){
                setState(() {
                  content = textchange;
                });
              },
            ),
        ],
         ),
     );
  }
}
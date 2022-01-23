import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:dummy/widgets/paragraph_text.dart';
import 'show_text.dart';

class AddTextScreen extends StatefulWidget {
  final ParagraphText? paragraphText;
  final bool isEdit;
  const AddTextScreen({ Key? key ,this.paragraphText, required this.isEdit}) : super(key: key);

  @override
  _AddTextScreenState createState() => _AddTextScreenState();
}

class _AddTextScreenState extends State<AddTextScreen> {

  late String title;
  late String content;

  @override
  void initState(){
    super.initState();
    title = widget.paragraphText?.title ?? "";
    content = widget.paragraphText?.content ?? "";
  }

  void addParagraphText(String title,String content){
    final paragraphText = ParagraphText(title, content);
    paragraphText.addToAll();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> ShowText(paragraphText: paragraphText))
    );
  }

  void editParagraphText(ParagraphText? p,String title, String content) {
    p?.delete();
    final paragraphText = ParagraphText(title, content);
    paragraphText.addToAll();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> ShowText(paragraphText: paragraphText))
    );
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('Input Text'),
       ),
       body:
       Column(
        
        children: [
          const SizedBox(height: 40,),
          TextFormField(
            minLines: 1,
            maxLines: 2,
            initialValue: title,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),  
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFD3D3D3),
                    width: 10,
                  )
                ),  
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
              initialValue: content,
              minLines: 16,
              maxLines: 40,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFD3D3D3),
                    width: 5,
                  )
                ),
                
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
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                
                onPressed:(){
                  if (widget.isEdit) {
                  editParagraphText(widget.paragraphText, title, content);
                } else {
                  addParagraphText(title,content);
                }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  
                )
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              )
            ],
          ),
        ],
      ),

     );
  }
}
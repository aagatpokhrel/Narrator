import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:file_picker/file_picker.dart';
import 'package:narrator/utils/session_data.dart';
import 'package:narrator/utils/voice_handler.dart';

class ContentScreen extends StatefulWidget {

  final int indexData;
  final Session session;
  const ContentScreen({Key? key, required this.indexData, required this.session})
    :super(key: key);

  @override
    _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  bool isEdit = false;
  late Data data;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late  VoiceHandler _voiceHandler;

  // FlutterTts flutterTts = FlutterTts();
  late String contentOfFile;
  final stt.SpeechToText _speech= stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';

  @override
  void initState() {
    super.initState();
    _voiceHandler = VoiceHandler(widget.session.userId);
    if (widget.indexData >= widget.session.allTexts.length){
      data = Data('','',-1);
      isEdit = true;
      _titleController.text = '';
      _descriptionController.text = '';
    }
    else{
      data = widget.session.allTexts[widget.indexData];
      _titleController.text = data.title;
      _descriptionController.text = data.content;
    }
    _voiceHandler.setContent(data.title , data.content);
  }

  @override
  void dispose(){
    super.dispose();
    _voiceHandler.stop();
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
            actions: [              
              isEdit ? IconButton(
                icon: const Icon(Icons.check_circle_outline_outlined),
                onPressed: () async {
                  if (data.textId >=0){
                    if (data.content=='' && data.title==''){
                      widget.session.deleteData(data.textId);
                      data.textId = -1;
                      isEdit = true;
                    }
                    else{
                      widget.session.deleteData(data.textId);
                      final textid = await widget.session.addData(data.title, data.content);
                      data.textId = textid;
                      isEdit = false;
                    }
                  }
                  else{
                    if (data.content !='' || data.title!=''){
                      print ("Hurray");
                      final int textid = await widget.session.addData(data.title, data.content);
                      print ("Bye");
                      data.textId = textid;
                      isEdit = false;
                    }
                  }
                  _voiceHandler.setContent(data.title, data.content);
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                  });
                },
              ):
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async{
                  if (data.textId >= 0){
                    widget.session.deleteItem(widget.indexData);
                  }
                  setState(() {
                  });
                  Navigator.pop(context);
                },
              ),
            ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (!isEdit)? AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 1000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ): ((_descriptionController.text==''))? FloatingActionButton(
        child: const Icon(Icons.upload_file_outlined) ,
        onPressed: ()async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['txt'],
          );   
          if (result != null) {
            File file = File(result.files.single.path.toString());
            final fileContents = file.readAsStringSync();
            data.content = fileContents.toString();
            _descriptionController.text = fileContents.toString();
          }
        },
      ):null,

      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child:Column(
            children: [
              TextField(
                onTap: (){
                  setState(() {
                    isEdit = true;
                  });
                },
                onChanged: (text){
                  data.title = text;
                },
                controller: _titleController,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                  ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title'
                ),
              ),
              TextField(
                onTap: (){
                  setState(() {
                    isEdit = true;
                  });
                },
                onChanged: (text){
                  data.content = text;
                  setState(() {
                    isEdit = true;
                  });
                },
                maxLines: 14,
                controller: _descriptionController,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    height: 1.5,
                  ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start Wrting Text',
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _voiceHandler.stop();
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _voiceHandler.handleText(_text);
    }
  }
}
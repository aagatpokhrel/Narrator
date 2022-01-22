import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:dummy/widgets/paragraph_text.dart';

class ShowText extends StatefulWidget {

  final ParagraphText paragraphText;
  const ShowText({Key? key, required this.paragraphText}) : super(key: key);

  @override
    _ShowTextState createState() => _ShowTextState();
}

class _ShowTextState extends State<ShowText> {
  FlutterTts flutterTts = FlutterTts();
  late String contentOfFile;
  final stt.SpeechToText _speech= stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
  }

  void pause() async{

  }

  void speak() async{
    flutterTts.speak(widget.paragraphText.content);
  }

  void stop() async{
    flutterTts.stop();
  }

  @override
  void dispose(){
    flutterTts.stop();
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paragraphText.title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(
            widget.paragraphText.content,
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
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
        flutterTts.stop();
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_text=='play'){
        speak();
      }
      if (_text=='stop'){
        stop();
      }
      else{
        const url = 'http://127.0.0.1:5000/question_answer';
        
        final post_response = http.post(url, body: json.encode({
            'question':_text,
            'title':widget.paragraphText.title})
        );

        final get_response =await http.get(url);
        final decoded = json.decode(get_response.body) as Map<String,dynamic>;
        final final_respone = decoded['answer'];
        print(final_respone);
        
      }
    }
  }
}
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String,dynamic> voiceData = {'voice':'Female','speed':1, 'pitch':1};

class VoiceHandler{
  FlutterTts flutterTts = FlutterTts();
  late int userId;
  late String content;
  late String title;
  final String femalevoice = "Karen";
  final String malevoice = "Ken"; 

  VoiceHandler(int _userId){
    userId = _userId;  
    flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
  }

  setContent(String _title, String _content){
    content = _content;
    title = _title;
  }

  handleText(String text){
    // final String voice = (voiceData['voice']=="Female")? femalevoice:malevoice;
    // flutterTts.setVoice({'name':voice});
    if (text.toLowerCase()=='play'){
        speak();
      }
    else if (text.toLowerCase()=='stop'){
      stop();
    }
    else{
      const url = 'http://127.0.0.1:5000/question_answer';
      
      http.post(url, body: json.encode({
          'question':text,
          'title':title,
          'user_id':userId,
        })
      ).then((response) {
          flutterTts.speak(response.body);
      });
    }
  }
  void speak(){
    flutterTts.speak(content);
  }

  void stop(){
    flutterTts.stop();
  }

  void pause(){

  }

  void playFrom(){

  }

  void changeVoice(){

  }
}
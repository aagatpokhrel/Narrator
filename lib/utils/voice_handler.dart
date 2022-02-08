import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_azure_tts/flutter_azure_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';
import 'package:narrator/utils/constants.dart';
import 'package:flutter_tts/flutter_tts.dart';

Map<String,dynamic> voiceData = {
  'gender':true,
  'speed':1,
  'pitch':1
}; //gender 1 represents male and 0 for female

class VoiceHandler{
  late int userId;
  late String content;
  late int textId;
  late Future<Uint8List> audiobytes;

  final _player = AudioPlayer();
  late FlutterTts flutterTts;

  late Future<Voice> voice;

  VoiceHandler(int _userId){
    flutterTts = FlutterTts();
    userId = _userId;  
    AzureTts.init(
      subscriptionKey: "81662ce970af461690a18918d4150812", //protect this
      region: "southeastasia", //protect this.
      withLogs: true
    );
    voice = setVoice();
  }

  Future<Voice> setVoice() async{
    final voicesResponse =await AzureTts.getAvailableVoices() as VoicesSuccess;
    return voicesResponse.voices
      .where((element) =>
          element.voiceType == "Neural" && element.locale.startsWith("en-") && element.localName=="Ashley")
      .toList(growable: false)[0];
  }

  Future<Uint8List> getAudio() async{
    TtsParams params = TtsParams(
      voice: await voice,
      audioFormat: AudioOutputFormat.audio16khz32kBitrateMonoMp3,
      text: content
    );
    final ttsResponse = await AzureTts.getTts(params) as AudioSuccess;
    return ttsResponse.audio;
  } 

  setContent(int _textId, String _content) async{
    content = _content;
    textId = _textId;
    audiobytes = getAudio();
  }

  handleText(String text){
    
    if (text.toLowerCase()=='play'){
        playContent();
    }
    else if (text.toLowerCase()=='stop'){
      stop();
    }
    else{
      String url = baseUrl+'question_answer';
      
      http.post(Uri.parse(url), body: json.encode({
          'question':text,
          'textId':textId,
          'user_id':userId,
        })
      ).then((response) {
          speak(response.body);
      });
    }
  }
  void speak(text) async{
    await flutterTts.speak(text);
  }
  void playContent() async{
    _player.playBytes(await audiobytes);
  }

  void stop(){
    flutterTts.stop();
    _player.stop();
  }

  void pause(){

  }
  void changeVoice(){

  }
}
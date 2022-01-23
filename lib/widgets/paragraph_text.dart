import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final List<ParagraphText> allTexts= [
  ParagraphText(
    'Flutter',
    'this app is made with flutter'
  ),
  ParagraphText(
    'Communism',
    'Communism (from Latin communis) is a philosophical, social, political, and economic ideology and movement whose goal is the establishment of a communist society, namely a socioeconomic order structured upon the ideas of common ownership of the means of production and the absence of social classes, money,[3][4] and the state.[5][6] Communism is a specific, yet distinct, form of socialism. Communists agree on the withering away of the state but disagree on the means to this end, reflecting a distinction between a more libertarian approach of communization, revolutionary spontaneity, and workers self-management, and a more vanguardist or Communist party-driven approach through the development of a constitutional socialist state. Variants of communism have been developed throughout history, including anarcho-communism and Marxist schools of thought. Communism includes a variety of schools of thought which broadly include Marxism, Leninism, and libertarian communism as well as the political ideologies grouped around both, all of which share the analysis that the current order of society stems from capitalism, its economic system and mode of production, namely that in this system there are two major social classes, the relationship between these two classes is exploitative, and that this situation can only ultimately be resolved through a social revolution.[8][nb 1] The two classes are the proletariat (the working class), who make up the majority of the population within society and must work to survive, and the bourgeoisie (the capitalist class), a small minority who derives profit from employing the working class through private ownership of the means of production. According to this analysis, revolution would put the working class in power and in turn establish social ownership of the means of production which is the primary element in the transformation of society towards a communist mode of production.'
  ),
  ParagraphText(
    'Tea',
    'it is everything'
  ),
];

class ParagraphText {
  late final String title;
  late final String content;

  ParagraphText(
    this.title, 
    this.content
  );

  // duplicate add is possible (needs some work here)
  void addToAll() async{
    allTexts.add(
      ParagraphText(title,content)
    );
    const url = 'http://127.0.0.1:5000/add_data';
    http.Response response =await http.post(url, body: json.encode({
      'title':title,
      'content':content})
    ); 
  }
  void delete(){
    allTexts.remove(this);
  }
}

ParagraphText getFromTitle(String title){
  for (var i=0; i<allTexts.length;i++){
    if (allTexts[i].title==title){
      return allTexts[i];
    }
  }
  return ParagraphText('','');
}



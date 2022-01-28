import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data.dart';

class Session{

  late int userId;
  late String userName;
  late String passWord;
  late List<Data> allTexts;

  Session(){
    allTexts = [];
  }

  Future<int> addData(String title, String content) async{
    const url = 'http://127.0.0.1:5000/add_data';
    late int textid;
    await http.post(url, body: json.encode({
      'title':title,
      'content':content,
      'user_id':userId
    })
    ).then((response){
      print ('I am inside');
      textid = int.parse(response.body);
      if (response.body!="404"){
        final a = Data(title,content,textid);
        allTexts.add(a);        
      }
    }); 
    return textid;
  }

  void deleteItem(int index) async{
    final _textId = allTexts[index].textId;
    allTexts.removeAt(index);
    const url = 'http://127.0.0.1:5000/delete_data';
    await http.post(url, body: json.encode({
      'user_id':userId,
      'text_id':_textId,
      })
    );
  }

  void deleteData(int _textId) async{
    for (int i=0; i<allTexts.length; i++){
      if (allTexts[i].textId == _textId){
        allTexts.remove(allTexts[i]);
      }
    }
    const url = 'http://127.0.0.1:5000/delete_data';
    await http.post(url, body: json.encode({
      'user_id':userId,
      'text_id':_textId,
      })
    );
  }

  Future<List<Data>> getAllTexts() async {
    const url = 'http://127.0.0.1:5000/get_data';
    http.post(url, body:json.encode({
      'user_id': userId
    })).then((response){
      final decoded = json.decode(response.body) as Map<String,dynamic>;
      final newdecoded= decoded['json_list'];
      for (var i=0;i<newdecoded.length;i++){
        final p = Data(
          newdecoded[i]['title'],
          newdecoded[i]['content'],
          newdecoded[i]['text_id']
        );
        allTexts.add(p);
      }
    });
    return allTexts;
  }

  Future<bool> setUser(String username, String password) async{
    const url = 'http://127.0.0.1:5000/login';
    await http.post(url, body: json.encode({
      'username':username,
      'password':password
    })).then((response){
      if (response.body=="404"){
        return false;
      }
      else{
        userName = username;
        passWord = password;
        userId = int.parse(response.body); 
        return true;
      }
    });
    return false;
  }

  Future <bool> addUser(String username, String password)async {
    const url = 'http://127.0.0.1:5000/register';
    await http.post(url, body: json.encode({
      'username':username,
      'password':password
    })).then((response){
      if (response.body=="404"){
        return true;
      }
      else{
        return false;
      }
    });
    return false;
  }
}
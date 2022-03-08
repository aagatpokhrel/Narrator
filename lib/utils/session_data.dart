import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:narrator/utils/constants.dart';

class Data{
  late String title;
  late String content;
  late String date;
  late int textId;

  Data(
    this.title, 
    this.content,
    this.date,
    this.textId,
  );
}

class Session{
  late int userId;
  late String fullName;
  late String userName;
  late String passWord;
  late List<Data> allTexts;

  Session(){
    allTexts = [];
  }

  Future<int> addData(String title, String content, String date) async{
    String url = baseUrl+'add_data';
    late int textid;
    await http.post(Uri.parse(url), body: json.encode({
      'title':title,
      'content':content,
      'date':date,
      'user_id':userId
    })
    ).then((response){
      textid = int.parse(response.body);
      if (response.body!="404"){
        final a = Data(title,content,date,textid);
        allTexts.add(a);        
      }
    }); 
    return textid;
  }

  void deleteItem(int index) async{
    final _textId = allTexts[index].textId;
    allTexts.removeAt(index);
    String url = baseUrl+'delete_data';
    await http.post(Uri.parse(url), body: json.encode({
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
    String url = baseUrl+'delete_data';
    await http.post(Uri.parse(url), body: json.encode({
      'user_id':userId,
      'text_id':_textId,
      })
    );
  }

  Future<List<Data>> getAllTexts() async {
    String url = baseUrl+'get_data';
    await http.post(Uri.parse(url), body:json.encode({
      'user_id': userId
    })).then((response){
      final decoded = json.decode(response.body) as Map<String,dynamic>;
      final newdecoded= decoded['json_list'];
      for (var i=0;i<newdecoded.length;i++){
        final p = Data(
          newdecoded[i]['title'],
          newdecoded[i]['content'],
          newdecoded[i]['date'],
          newdecoded[i]['text_id']
        );
        allTexts.add(p);
      }
    });
    return allTexts;
  }

  Future<bool> setUser(String username, String password) async{
    String url = baseUrl+'login';
    await http.post(Uri.parse(url), body: json.encode({
      'username':username,
      'password':password
    })).then((response){
      if (response.body=="404"){
        return false;
      }
      else{
        final decoded = json.decode(response.body) as Map<String,dynamic>;
        fullName = decoded['fullname'];
        userName = decoded['username'];
        passWord = decoded['password'];
        userId = decoded['user_id']; 
        return true;
      }
    });
    return false;
  }

  Future <bool> addUser(String fullname, String username, String password)async {
    String url = baseUrl+'register';
    print ("Hello World again");
    await http.post(Uri.parse(url), body: json.encode({
      'fullname':fullname,
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
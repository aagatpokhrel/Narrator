import 'package:flutter/cupertino.dart';

import 'home_screen.dart';
import 'register_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/paragraph_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/images/logo.png')),
              ),
            ),
            Padding(
              padding:const EdgeInsets.fromLTRB(
                15.0,
                20.0,
                15.0,
                0.0,
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  username = value;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter password',
                ),
                cursorColor: Colors.red,
                cursorRadius: const Radius.circular(8.0),
                cursorWidth: 8.0,
              ),
            ),
            Container(
              height: 50,
              width: 100,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async{
                  const url = 'http://127.0.0.1:5000/login';
                  await http.post(url, body: json.encode({
                    'username':username,
                    'password':password})
                  ).then((response){
                    print (response);
                    if (response=="404"){
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Invalid Username of Password',
                        ),
                      ),
                     );
                    }
                    else{
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) => HomeScreen(userId: 1,))
                      );
                    }
                  });
                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill out all fields',
                        ),
                      ),
                    );
                    return;
                  }
                  
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height:20),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Nope',
                    ),
                  ),
                );
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            const SizedBox(height:30),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => RegisterScreen(),
                  ),
                );
              },
              child: const Text(
                'New user? Create an account',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:dummy/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dummy/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/images/logo.png')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                15.0,
                20.0,
                15.0,
                0.0,
              ),
              child: TextField(
                onChanged: (value) {
                  username = value;
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration:const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter username'),
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
                decoration:const InputDecoration(
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
              margin: const EdgeInsets.only(top: 20),
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: ()async {
                  const url = 'http://127.0.0.1:5000/register';
                  await http.post(url, body: json.encode({
                    'username':username,
                    'password':password})
                  ).then((response){
                    if (response=="404"){
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Username already Exists',
                        ),
                      ),
                     );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Successfully created account'),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) => HomeScreen(userId: 1,))
                      );
                    }
                      // Navigator.pop(context);
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
                child:const Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
              },
              child: const Text(
                'Already a member? Login',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
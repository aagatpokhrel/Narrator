import 'package:narrator/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrator/utils/session_data.dart';
import 'package:narrator/utils/voice_handler.dart';

class AccountScreen extends StatefulWidget {
  
  final Session session;
  const AccountScreen({ Key? key, required this.session}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Account Settings'),
      ),
      body:SettingsList(
        sections: [
          CustomSettingsSection(
            
            child: Column(
              children: [
                const SizedBox(height: 20,),
                CircleAvatar(
                  backgroundColor: const Color(0xffD3D3D3),
                  child: Text(
                    widget.session.userName[0],
                    textAlign: TextAlign.left,
                  ),
                  radius: 50,
                ),
                const SizedBox(height: 15,),
                Text(
                  widget.session.userName,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ),
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: const Icon(Icons.format_paint),
                title:const Text('Enable Dark Theme'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Voice Settings'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: voiceData['gender'] ? const Icon(Icons.male) :const Icon(Icons.female),
                title: const Text('Voice'),
                value: voiceData['gender'] ? const Text('Male'): const Text('Female'),
                onPressed: (text){
                  setState(() {
                    if (voiceData['gender']){
                      voiceData['gender'] = false;
                    }
                    else{
                      voiceData['gender'] = true;
                    }
                  });
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.speed),
                title: const Text('Speed'),
                value: Text('${voiceData['speed']}x'),
                onPressed: (text){
                  setState(() {
                    if (voiceData['speed'] == 1){
                    voiceData['speed'] = 1.5;
                    }
                    else if(voiceData['speed'] == 1.5){
                      voiceData['speed'] = 2;                    
                    }
                    else if (voiceData['speed']== 2){
                      voiceData['speed'] = 1;
                    }
                  });
                }
              ),
              SettingsTile.navigation(
                onPressed: (text){
                  setState(() {
                    if (voiceData['pitch'] == 1){
                    voiceData['pitch'] = 2;
                    }
                    else if(voiceData['pitch'] == 2){
                      voiceData['pitch'] = 0;                    
                    }
                    else if (voiceData['pitch']== 0){
                      voiceData['pitch'] = 1;
                    }
                  });
                },
                leading: const Icon(Icons.arrow_upward),
                title: const Text('Pitch'),
                value: Text('${voiceData['pitch']}'),
              ),
            ],
          ),
          CustomSettingsSection(
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Container(
                  height: 50,
                  width: 150,
                  // margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context)=> LoginScreen(),)
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
import 'package:dummy/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:dummy/utils/session.dart';

class AccountScreen extends StatefulWidget {
  
  final Session session;
  const AccountScreen({ Key? key, required this.session}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
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
              SettingsTile.navigation(
                leading: const Icon(Icons.font_download),
                title: const Text('Font Size'),
                value:const  Text('16'),
              ),
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
                leading: Icon(Icons.male),
                title: Text('Voice'),
                value: Text('Male'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.speed),
                title: Text('Speed'),
                value: Text('1x'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.male),
                title: Text('Pitch'),
                value: Text('1'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Highlight Answered Data'),
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
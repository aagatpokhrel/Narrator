import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'account_screen.dart';
import 'content_screen.dart';
import 'package:intl/intl.dart';
import 'package:dummy/utils/session.dart';
import 'package:dummy/utils/data.dart';

class HomeScreen extends StatefulWidget {
  final Session session;
  const HomeScreen({Key? key, required this.session,}): super(key:key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  late List<bool> isSelected= [true,false];
  late bool firstRun = true;

  late Future <List<Data>> futureDatas;
  
  @override
  void initState() {
    super.initState();
    futureDatas = widget.session.getAllTexts();
    // widget.session.allTexts = futureDatas as List<Data>; 
  }

  @override
  Widget build(BuildContext context) {
    String _selectedGender = 'male';
    final TextEditingController _searchController = TextEditingController();
    
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF), // WHITE
      body: FutureBuilder<List<Data>>(
            future: futureDatas,
            builder: (context, snapshot) {
              if (snapshot.hasData){
                return CustomScrollView(
                  slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: false,
                    title:const Text('Narrator'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.account_box_outlined),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context)=> AccountScreen(session: widget.session))
                          );
                        },
                      ),
                    ],
                    bottom: AppBar(
                      title: Container(
                        width: double.infinity,
                        height: 40,
                        color: Colors.white,
                        child: Center(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (text){},
                            decoration: const InputDecoration(
                                hintText: 'Search for Texts',
                                prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                      
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final currentText = snapshot.data![index];
                        print ("Print ???");
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context)=> ContentScreen(indexData: index,session: widget.session,))
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(30.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding:const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          currentText.title,
                                          style:const  TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          currentText.content,
                                          style: const TextStyle(
                                            fontSize: 12, 
                                          ),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(DateFormat.jm().format(DateTime.now())),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: snapshot.data!.length,
                    ),
                  ),         
                ],
              );
            }
            else{
              return const CircularProgressIndicator();
            }
          }
        ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => ContentScreen(indexData:widget.session.allTexts.length,session: widget.session)
            )
          );
        },
        child: const Icon(Icons.add),
      ) 
    );
  }
}
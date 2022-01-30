import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:narrator/screens/account_screen.dart';
import 'package:narrator/screens/content_screen.dart';
import 'package:intl/intl.dart';
import 'package:narrator/utils/session_data.dart';

class HomeScreen extends StatefulWidget {
  final Session session;
  const HomeScreen({Key? key, required this.session,}): super(key:key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  late Future <List<Data>> futureDatas;
  String searchText = "";
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    futureDatas = widget.session.getAllTexts();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF), // WHITE
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget> [
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
                      onChanged: (text){
                        setState(() {
                          searchText = text;
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: 'Search for Texts',
                          prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: FutureBuilder<List<Data>>(
          future: futureDatas,
          builder: (context, snapshot){
            if (snapshot.hasData){
              List<Data> temp = [];
              List<int> indices = [];
              for (int i=0;i <snapshot.data!.length; i++){
                if (snapshot.data![i].title.toLowerCase().contains(searchText.toLowerCase())){
                  temp.add(snapshot.data![i]);
                  indices.add(i);
                }
              }
              return ListView.builder(
                itemCount: temp.length,
                itemBuilder: (BuildContext context, int index){
                  final currentText = temp[index];
                  return InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context)=> ContentScreen(indexData: indices[index],session: widget.session,))
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                          Expanded(
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
                          Text(DateFormat.jm().format(DateTime.now())),
                        ],
                      ),
                    ),
                  );
                }
              );
            }
            else{
              return const Center(
                child:CircularProgressIndicator()
              );
            }
          } ,
        ),
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
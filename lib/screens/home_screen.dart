import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dummy/utils/paragraph_text.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

import 'content_screen.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({Key? key, required this.userId}): super(key:key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool openDrawer = false ;
  @override
  void initState() {
    super.initState();
    getTextData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF), // WHITE
      body: CustomScrollView(
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
                  showModalSideSheet(
                   context: context,
                    body: ListView.builder(
                      itemBuilder:(context,index){
                        return ListTile(
                          leading: const Icon(Icons.face),
                          title: Text("I am on $index index"),
                          trailing: const Icon(Icons.safety_divider),
                        );
                      },
                    )
                  );
                },
              ),
            ],
            bottom: AppBar(
              title: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: const Center(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search for Texts',
                        prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 20,),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final currentText = allTexts[index];
                return InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context)=> ShowContent(paragraphText:currentText,))
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
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
                                ),
                                Text(
                                  currentText.content,
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
              childCount: allTexts.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => ShowContent(paragraphText:ParagraphText('',''),)
            )
          );
        },
        child: const Icon(Icons.add),
      ) 
    );
  }
}
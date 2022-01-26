import 'package:dummy/screens/input_screen.dart';
import 'package:flutter/material.dart';
import 'package:dummy/widgets/paragraph_text.dart';
import 'content_screen.dart';
import 'package:flutter/cupertino.dart';

class Feed extends StatefulWidget {
  const Feed({ Key? key }) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override void initState() {
    // TODO: implement initState
    super.initState();
    // getTextData();
  }

  @override
  Widget build(BuildContext context) {
    
      return SingleChildScrollView(
      child: Column(
        children: [
          Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(
                'Your Texts',
                style:TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height:60,),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: allTexts.length,
            itemBuilder: (context, int index) {
              final allText = allTexts[index];
              return ListTile(
                title: Text(allText.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(
                          context, 
                          CupertinoPageRoute(
                            builder: (context) => InputScreen(paragraphText: allText,isEdit: true,))
                        );
                      },
                      icon: const Icon(Icons.edit)
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: (){
                        setState(() {
                          allText.delete(1);
                        });
                      },
                    ),
                      
                  ],
                ),
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ShowContent(paragraphText:allText)));
                  // print('tapped');
                },
              );

            })
        ],
      ),
    );
  }
}

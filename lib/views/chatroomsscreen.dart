import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context,snapshot){
          return snapshot.hasData?ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                return ChatRoomTile(
                  snapshot.data.documents[index].data["chatroomId"]
                      .toString().replaceAll("_", "")
                      .replaceAll(Constants.myName, ""),
                    snapshot.data.documents[index].data["chatroomId"]
                );
              }):Container();
        }
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }
  getUserInfo()async{
    Constants.myName=await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream=value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Home Screen"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=>Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>SearchScreen()
        )
        );
      }),
      body: chatRoomList(),
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  final String userName,chatRoomId;
  ChatRoomTile(this.userName,this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationScreen(chatRoomId)));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10,left: 8,right: 8),
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          //border: BorderSide()
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),

              child: Text("${userName.substring(0,1)}",style: TextStyle(fontSize: 30,color: Colors.white),),
            ),
            SizedBox(width: 5,),
            Text(userName,style: TextStyle(fontSize: 18,color: Colors.black),)
          ],
        ),
      ),
    );
  }
}

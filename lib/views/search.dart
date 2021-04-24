import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods=new DatabaseMethods();
  TextEditingController searchTextEditingController=new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return SearchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }

  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapshot=val;
      });
    });
  }
  /// create chatroom ,send user to conversation screen ,pusreplecement
  createChatroomAndStartConversation(String userName){
    if(userName !=Constants.myName){
      String chatRoomId=getChatRoomId(userName,Constants.myName);

      List<String> users =[userName,Constants.myName];
      Map<String , dynamic>chatRoomMap={
        "users":users,
        "chatroomId":chatRoomId

      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context,MaterialPageRoute(
          builder: (context) =>ConversationScreen(chatRoomId)));
    }else{
      print("You can not send message to yourself");
    }
  }

  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName,style: simpleTextFieldStyle(),),
              Text(userEmail,style: simpleTextFieldStyle(),)

            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(
                  userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Text("Message",style: TextStyle(fontSize: 18,color: Colors.black),),
            ),
          )
        ],
      ),
    );
  }



  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Search"), 
        centerTitle: true,
      ),
      body: Container(
         child: Column(
           children: [
             Container(
               color: Colors.white70,
               padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
               child: Row(
                 children: [
                   Expanded(
                       child: TextField(
                         controller: searchTextEditingController,
                         decoration: InputDecoration(
                           hintText: "Search username...",
                           border: InputBorder.none,
                           fillColor: Colors.white10,
                           filled: true,
                         ),
                       )),
                   GestureDetector(
                     onTap: (){
                       initiateSearch();
                     },
                     child: Container(
                       height: 40,
                       width: 40,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(40)

                       ),
                       padding: EdgeInsets.all(12),
                       child: Image.asset("images/searchicon.png"),
                     ),
                   )
                 ],
               ),
             ),
             searchList()
           ],
         ),
      ),
    );
  }

}



// class SearchTile extends StatelessWidget {
//   final String userName;
//   final String userEmail;
//   SearchTile({this.userName,this.userEmail});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
//       child: Row(
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(userName,style: simpleTextFieldStyle(),),
//               Text(userEmail,style: simpleTextFieldStyle(),)
//
//             ],
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: (){
//               createChatroomAndStartConversation(userName);
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
//               child: Text("Message",style: TextStyle(fontSize: 18,color: Colors.black),),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

getChatRoomId(String a, String b){
  if (a.substring(0,1).codeUnitAt(0)> b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}

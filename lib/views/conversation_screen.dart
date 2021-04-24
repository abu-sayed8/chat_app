import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

DatabaseMethods databaseMethods=new DatabaseMethods();
TextEditingController messageEditingController=new TextEditingController();

Stream chatMessageStream;

  Widget ChatMessageList(){
    return  StreamBuilder(
        stream:  chatMessageStream,
        builder: (context,snapshot){
          return snapshot.hasData?ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                return MessaageTile(
                  snapshot.data.documents[index].data["messages"],
                  snapshot.data.documents[index].data["sendBy"]==Constants.myName,

                );
              }
          ):Container();
        }
    );
  }
  sendMessage(){
    if(messageEditingController.text.isNotEmpty){
      Map<String ,dynamic>messageMap={
        "messages":messageEditingController.text,
        "sendBy":Constants.myName,
        "time":DateTime.now().microsecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageEditingController.text="";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream=value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : appBarMain("Conversation Screen"),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white70,
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          decoration: InputDecoration(
                            hintText: "Message...",
                            border: InputBorder.none,
                            fillColor: Colors.white10,
                            filled: true,
                          ),
                        )),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40)

                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("images/send.png"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessaageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessaageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: EdgeInsets.only(bottom: 5,top: 5,right: 5,left: 5),
      padding: EdgeInsets.only(left: isSendByMe?0:10,right: isSendByMe?16:0),
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),

        decoration: BoxDecoration(
          gradient: LinearGradient(colors: isSendByMe?[
            const Color(0xff007ef4),
            const Color(0xff2A75BC),
          ]
          :
          [
            const Color(0x1AFFFFFF),
            const Color(0x1AFFFFFF),
          ]
          ),
          borderRadius:isSendByMe? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23),
          ):BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
          )
        ),
        child: Text(message,style: TextStyle(
          fontSize: 18,
          color: Colors.white,

        ),),

      ),
    );
  }
}


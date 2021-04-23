import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatroomsscreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey=GlobalKey<FormState>();
  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();

  TextEditingController emailTextEditingController=new TextEditingController();
  TextEditingController passwordTextEditingController=new TextEditingController();
  bool isLoading=false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if (formKey.currentState.validate()){
     // HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo=val;
        HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      });
      //TODO function a get userDetails
      setState(() {
        isLoading=true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
        if(val!=null){

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=>ChatRoom()
          ));
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain("Chat App"),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("images/v.jpg"),
                ),
                accountName: Text("Abu Sayed"),
                accountEmail: Text("s@gmail.com")),
            ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.pop(context);
                print("Home");
              },
            ),
            Divider(
              height: 8.0,
              color: Colors.black12,
              indent: 18.0,
            ),
            ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.pop(context);
                print("Settings");
              },
            ),
            Divider(
              height: 8.0,
              color: Colors.black12,
              indent: 18.0,
            ),
            ListTile(
              title: Text("Rate App"),
              leading: Icon(Icons.star),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.pop(context);
                print("Rate App");
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-50,
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                   Form(
                     key: formKey,
                     child: Column(
                       children: [
                         TextFormField(
                             validator: (val){
                               return RegExp (
                                   r"^(?=[a-zA-Z0-9,!@#$&*()_'+-=<>.?{}\[\]|;:\s]*$)(?!.*[/])+")
                                   .hasMatch(val) ? null:"Please Provide a valid email Id";
                             },
                             controller: emailTextEditingController,
                             style: simpleTextFieldStyle(),
                             decoration: inputTextField('email or phone number')
                         ),
                         TextFormField(
                             obscureText: true,
                             validator: (val){
                               return val.length>4 ? null:"Please provide your password";
                             },
                             controller: passwordTextEditingController,

                             style: simpleTextFieldStyle(),
                             decoration: inputTextField('password')
                         ),
                       ],
                     ),
                   ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: Text("Forget Password?",style: simpleTextFieldStyle(),),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("SignIn",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30)
                    ),

                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("Sign In With Google",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(30)
                  ),

                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don't have an account?  ",style:simpleTextFieldStyle()),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Register now",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),
                          )
                      ),
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
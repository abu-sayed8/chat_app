import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatroomsscreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading=false;
  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  //HelperFunctions helperFunctions=new HelperFunctions();

  final formKey=GlobalKey<FormState>();
  TextEditingController userNameTextEditingController=new TextEditingController();
  TextEditingController emailTextEditingController=new TextEditingController();
  TextEditingController passwordTextEditingController=new TextEditingController();
  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String, String> userInfoMap ={
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text,
        "password" : passwordTextEditingController.text,
      };
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      setState(() {
       isLoading=true;
     });
     authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
         passwordTextEditingController.text).then((val){
           //print("${val.uid}");


       databaseMethods.uploadUserInfo(userInfoMap);
           HelperFunctions.saveUserLoggedInSharedPreference(true);
       Navigator.pushReplacement(context, MaterialPageRoute(
           builder: (context)=>ChatRoom()
       ));
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
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ):SingleChildScrollView(
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
                          return val.isEmpty||val.length<4 ?"Please provide your user Name":null;
                        },
                          controller: userNameTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: inputTextField('User name')
                      ),
                      TextFormField(

                        validator: (val){
                          return RegExp (
                              r"^(?=[a-zA-Z0-9,!@#$&*()_'+-=<>.?{}\[\]|;:\s]*$)(?!.*[/])+")
                              .hasMatch(val) ? null:"Please Provide a valid email Id";
                        },
                          controller: emailTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: inputTextField('Email or phone number')
                      ),
                      TextFormField(
                          obscureText: true,
                        validator: (val){
                          return val.length>4 ? null:"Please provide your password";
                        },
                          controller: passwordTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: inputTextField('Password'),
                      ),
                    ],
                  )),
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
                      signMeUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("SignUp",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
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
                    child: Text("Sign Up With Google",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
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
                      Text("Already have an account?  ",style:simpleTextFieldStyle()),
                      GestureDetector(
                        onTap: (){
                          widget.toggle();

                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("SignIn now",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),
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

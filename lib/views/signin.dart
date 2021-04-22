import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
                   TextField(
                     style: simpleTextFieldStyle(),
                    decoration: inputTextField('email or phone number')
                  ),
                TextField(
                  style: simpleTextFieldStyle(),
                    decoration: inputTextField('password')
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
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("SignIn",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30)
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
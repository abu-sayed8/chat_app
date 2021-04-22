import 'package:flutter/material.dart';
Widget appBarMain(String appBarTitle){
  return AppBar(
    title:Text(appBarTitle),
      elevation: 5.0,
      centerTitle: true
  );
}
InputDecoration inputTextField(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          color: Colors.black12
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black12,width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black12,width: 2.0),
      )
  );
}
TextStyle simpleTextFieldStyle(){
  return TextStyle(
    color: Colors.black,
    fontSize: 17,
  );
}
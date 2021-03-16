import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  String emailid, password;

@override
 void initState() {
   // TODO: implement initState
   super.initState();
   getPref();
 }

 getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      
      emailid = preferences.getString("emailid");
      print(emailid);
      password = preferences.getString("pass");
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Dashboard Page"),
      ),
      body: SingleChildScrollView(
        child: Container(
          //margin:EdgeInsets.only(top:ScreenUtil.statusBarHeight),
          child: Column(
            children: <Widget>[

              Padding(padding: EdgeInsets.all(30),
              child: Text(emailid,
              style: TextStyle(fontSize: 18)),
              ),
              Padding(padding: EdgeInsets.all(30),
              child: Text(password,
              style: TextStyle(fontSize: 18)),
              )
            ],
          )
        
        )
      ),
    );
  }
}
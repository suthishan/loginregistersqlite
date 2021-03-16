import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginregisterdemo/dbhelper/database-helper.dart';
import 'package:loginregisterdemo/models/user.dart';
import 'package:loginregisterdemo/pages/DashboardPage.dart';
import 'package:loginregisterdemo/pages/Registerform.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'HomePage.dart';

class LoginFormValidation extends StatefulWidget {
  @override
  _LoginFormValidationState createState() => _LoginFormValidationState();
}

class _LoginFormValidationState extends State<LoginFormValidation> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be atleast 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  }
  bool _isLoading = false;
  String emailid, pass;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          // autovalidate: true, //check for validation while typing
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 150,
                      height: 150,
                      child: Image.asset('assets/images/satvat_modified_logo.png')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter valid email id as abc@gmail.com'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      EmailValidator(errorText: "Enter valid email id"),
                    ]),
                    controller: username,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter secure password'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      MinLengthValidator(6,
                          errorText: "Password should be atleast 6 characters"),
                      MaxLengthValidator(15,
                          errorText:
                          "Password should not be greater than 15 characters")
                    ]),
                    controller: password,
                  //validatePassword,        //Function to check validation
                ),
              ),
              FlatButton(
                onPressed: () {
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () async {
                    if (formkey.currentState.validate()) {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) => HomePage()));
                      print("Validated");
                      emailid = username.text;
                      pass = password.text;
                      
                         String flagLogged = "logged";
                        _isLoading = true;
                        formkey.currentState.save();
                        var user = new User(null, emailid, pass, null);
                        var db = new DatabaseHelper();
                        var userRetorno = new User(null,null,null,null);
                        userRetorno = await db.selectUser(user);
                        


                        if(userRetorno != null){
                          flagLogged = "logged";
                          savePref(emailid, pass);
                          Navigator.push(context,
                          MaterialPageRoute(builder: (_) => WelcomePage()));
                        }else {
                          flagLogged = "not";
                        }
                       
                      


                    } else {
                      print("Not Validated");
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              InkWell(
                  child:  Text('New User? Create Account'),
                  onTap: () {
                    Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RegisterFormValidation()));
                  },
              )
             

            ],
          ),
        ),
      ),
    );
  }
  savePref(String user, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("emailid", emailid);
      preferences.setString("pass", pass);
      preferences.commit();
    });
  }
}
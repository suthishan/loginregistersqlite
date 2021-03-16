import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginregisterdemo/dbhelper/database-helper.dart';
import 'package:loginregisterdemo/models/user.dart';
import 'package:loginregisterdemo/pages/LoginForm.dart';

// import 'HomePage.dart';

class RegisterFormValidation extends StatefulWidget {
  @override
  _RegisterFormValidationState createState() => _RegisterFormValidationState();
}

class _RegisterFormValidationState extends State<RegisterFormValidation> {
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
  String userna, emailid, pass;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register Page"),
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
                        labelText: 'Username',
                        hintText: 'Enter username'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                    ]),
                    controller: username,
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter valid email id as abc@gmail.com'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      EmailValidator(errorText: "Enter valid email id"),
                    ]),
                    controller: email,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 30),
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
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    if (formkey.currentState.validate()) {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) => HomePage()));
                      print("Validated");
                      userna = username.text;
                      pass = password.text;
                      emailid = email.text;
                      setState(() {
                        _isLoading = true;
                        formkey.currentState.save();
                        var user = new User(userna, emailid, pass, null);
                        var db = new DatabaseHelper();
                        db.saveUser(user);
                        _isLoading = false;
                        Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginFormValidation()));
                        // Navigator.of(context).pushNamed("/login");
                      });
                    

                    } else {
                      print("Not Validated");
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class LoginPageStyle {}

class LoginPageTextField extends StatefulWidget {
  TextEditingController controller;
  TextInputType inputType;
  Icon icon;
  bool secureText = false;
  String hint;
  bool wrong;
  bool empty;
  String errorMessage;
  LoginPageTextField(
      {this.controller,
      this.inputType,
      this.icon,
      this.hint,
      this.wrong,
      this.empty,
      this.secureText,
      this.errorMessage});
  @override
  _LoginPageTextFieldState createState() => _LoginPageTextFieldState();
}

class _LoginPageTextFieldState extends State<LoginPageTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: widget.controller,
            onChanged: (val) {
              setState(() {
                widget.empty = false;
                widget.wrong = false;
              });
            },
            obscureText:
                widget.secureText ? widget.controller.text.length > 4 : false,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
                fillColor: Color(0xffFFFFFF),
                suffixIcon: widget.icon,
                filled: true,
                hintText: widget.hint,
                hintStyle: TextStyle(fontSize: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(30.0),
                )),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          widget.wrong
              ? widget.errorMessage
              : widget.empty
                  ? widget.hint
                  : '',
          style: TextStyle(color: Colors.red),
        )
      ],
    );
  }
}

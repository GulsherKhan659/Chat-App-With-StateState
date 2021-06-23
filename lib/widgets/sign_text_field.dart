import 'package:flutter/material.dart';


class TextFieldDesign extends StatelessWidget {
  final String? textTitle;
  final IconData? textIcon;
  final TextEditingController? textController;
  TextFieldDesign({this.textTitle,this.textIcon,this.textController});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: textController,
        cursorColor: Colors.white,
        style: TextStyle(
            color:Colors.white
        ),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder:OutlineInputBorder( gapPadding: 10,borderSide: BorderSide(color: Colors.white
              ,width: 3.0)) ,
          border: OutlineInputBorder( gapPadding: 10,borderSide: BorderSide(color: Colors.white
              ,width: 3.0)),
          labelText: textTitle,
          labelStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 1.2
          ),
          focusColor: Colors.white,
          fillColor: Colors.white,
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),),
          prefixIcon:Icon( textIcon,color:Colors.white),
        ),
      ),
    );
  }
}
 class PasswordFieldDesign extends StatefulWidget {
  PasswordFieldDesign({required this.passController});
final  passController;

  @override
  _PasswordFieldDesignState createState() => _PasswordFieldDesignState();
}

class _PasswordFieldDesignState extends State<PasswordFieldDesign> {
  bool isVisible = true;

  void changeIsVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: widget.passController,
        obscureText: isVisible,
        cursorColor: Colors.white,
        style: TextStyle(
            color: Colors.white
        ),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                gapPadding: 10, borderSide: BorderSide(color: Colors.white
                , width: 3.0)),
            border: OutlineInputBorder(
                gapPadding: 10, borderSide: BorderSide(color: Colors.white
                , width: 3.0)),
            labelText: "Enter Password Here",
            labelStyle: TextStyle(
                color: Colors.white,
                letterSpacing: 1.2
            ),
            focusColor: Colors.white,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2.0),),
            prefixIcon: Icon(Icons.lock, color: Colors.white),

            suffixIcon: IconButton(
              onPressed: () {
                changeIsVisible();
              },
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,),)
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/constants.dart';


class SignButtonDesign extends StatelessWidget {
  final buttonTitle;
  final Function signFunction;
  SignButtonDesign(this.buttonTitle,this.signFunction);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

          signFunction();
        }
      ,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.white60,
                spreadRadius: 1,
                offset:Offset(0,2),
                blurRadius: 3
            )
          ],
          color: Colors.white,
        ),
        child: Text(buttonTitle,style: kHeadingStyle1,),
      ),
    );
  }
}


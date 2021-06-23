import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/////////// Scolling Option at the Bottom of AppBar

const List<String> optionsList = ["Messages","Online","Status","Groups","Request"];

/////// Top Option  Scroll Text Style
const kUnActive = TextStyle(
  color: Colors.white54,
  fontSize: 16,
);

const kActive  = TextStyle(
  color: Colors.white,
  fontSize: 18,
);

/////////// New Message Badge
final kNewBadge = Container(
  height: 20,
  width: 35,
  decoration: BoxDecoration(
    color: Colors.black,
    borderRadius:BorderRadius.all(Radius.circular(10)),

  ),
  child: Center(child: Text('NEW',style: TextStyle(
      color: Colors.white,
      fontSize: 10,fontWeight: FontWeight.w900),)),
);




//////////////////Text Style//////////////////

const kHeadingStyle1= TextStyle(
  color: Colors.black,
  fontSize: 25,
  fontWeight: FontWeight.bold,
);
const kGreyTextStyle = TextStyle(
    letterSpacing: 1,
    color: Colors.black54
);
const kHeadingStyle2 = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
///////////////Sign Screen Style//////////
const kCornerRadius = Radius.circular(80);
const kHeadingStyleW = TextStyle(
  color: Colors.white,
  fontSize: 25,
  // fontWeight: FontWeight.bold,
);
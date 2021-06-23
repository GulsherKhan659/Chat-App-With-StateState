import 'package:flutter/material.dart';
import '../util/constants.dart';

class OptionWidget extends StatefulWidget {
  //const OptrionWidget({Key key}) : super(key: key);

  @override
  _OptionWidgetState createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  int _currentIndex =0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.only(top: 15),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: optionsList.length,
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  
                });
                _currentIndex = index;
              },
              child: Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  optionsList[index],
                  style:_currentIndex == index ? kActive:kUnActive,
                ),
              ),
            );
          }),
    );
  }
}

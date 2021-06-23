
import 'package:flutter/material.dart';


class SocialIconWidget  extends StatelessWidget {
  final firstImage,secondImage,firstFunction,secondFunction;
  SocialIconWidget({this.firstImage,this.secondImage,this.firstFunction,this.secondFunction});
  //  const FooterWidgetSocialIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _socialButton(firstImage,firstFunction),
          _socialButton(secondImage,secondFunction)
        ],
      ),
    );
  }
  Widget _socialButton(AssetImage assetImage,Function socialButtonFunction){
    return  GestureDetector(
      onTap: ()=> socialButtonFunction(),

    child:Container(
      height: 60,
      width: 60,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(

          shape: BoxShape.circle,
          color:Colors.white,
          image: DecorationImage(
          image:assetImage,
            fit: BoxFit.cover,
      ),
      ),)
    );
  }
}

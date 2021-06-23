import 'package:flutter/material.dart';


class DrawerWidget extends StatelessWidget {
  //const DrawerWidgey({Key key}) : super(key: key);
 final userImageUrl;
 final userName;
 final userEmail;
  DrawerWidget({
      this.userName,this.userEmail,this.userImageUrl
  });
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:Column(
        children: [
          Expanded(flex: 1,
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.fromLTRB(8, 10, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: userImageUrl == null ? DecorationImage(
                            image: AssetImage('assets/images/avator.jpg'),
                          ): DecorationImage(
                            image: NetworkImage('$userImageUrl'),
                          ),
                          ),
                      ),


                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$userName",
                          overflow: TextOverflow.ellipsis,),
                        SizedBox(
                          height: 8,
                        ),
                        Text("$userEmail",overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ],
      ),
              ),
            ),
          )),
          Expanded(flex: 5, child: Container(color: Colors.grey.shade50,)),
        ],
      ),
    );
  }
}

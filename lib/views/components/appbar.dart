import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final VoidCallback onPressed;

  CustomAppBar({
    //required Key key,
    required this.appBar,
    required this.title,
    required this.onPressed,
    this. center = true}); //: super(key: key);

  final AppBar appBar;
  final String title;
  final bool center;
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context){
    return AppBar(
      //key: _scaffold,
      title: Text("${title}", style: TextStyle(color : Colors.black)),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: center,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.info, color: Colors.black)
        )
      ],
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

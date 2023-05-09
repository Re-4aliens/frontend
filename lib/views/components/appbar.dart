import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final VoidCallback onPressed;

  CustomAppBar({
    //required Key key,
    required this.appBar,
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
   // required this.info,
    this. center = true
  }); //: super(key: key);

  final AppBar appBar;
  final String title;
  final bool center;
  final Color backgroundColor;
 // final bool info;
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context){
    return AppBar(
      //key: _scaffold,
      title: Text("${title}", style: TextStyle(color : Colors.black)),
      backgroundColor: backgroundColor,
      elevation: 0.0,
      centerTitle: center,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icon/icon_back.svg',
          width: 24,
          height: MediaQuery.of(context).size.height * 0.029,
        ),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          onPressed: onPressed,
          icon: SvgPicture.asset(
            'assets/icon/icon_info.svg',
            width: MediaQuery.of(context).size.width * 0.062,
            height: MediaQuery.of(context).size.height * 0.029,
            color: Color(0xff7898FF),),)
      ]);

  }
  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

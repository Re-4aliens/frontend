import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  CustomAppBar({
    //required Key key,
    required this.appBar,
    required this.title,
    required this.backgroundColor,
    required this.infookay,
    required this.infocontent,
    this. center = true
  }); //: super(key: key);

  final AppBar appBar;
  final String title;
  final bool center;
  final Color backgroundColor;
  final bool infookay;
  final String infocontent;
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return AppBar(
      //key: _scaffold,
      title: Text("${title}", style: TextStyle(color : Colors.black, fontWeight: FontWeight.w700)),
      backgroundColor: backgroundColor,
      elevation: 0.0,
      centerTitle: center,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icon/icon_back.svg',
          color: Color(0xff4D4D4D),
          width: 24,
          height: MediaQuery.of(context).size.height * 0.029,),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      actions: [
        if (infookay)
        IconButton(
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoTheme(
                    data: CupertinoThemeData(
                      barBackgroundColor: Colors.white
                    ),
                    child:Dialog(
                      backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child:ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.3 ,
                              maxHeight: MediaQuery.of(context).size.height * 0.3
                          ),
                          child:CupertinoAlertDialog(
                            title: SvgPicture.asset(
                              'assets/icon/icon_info.svg',
                              width: MediaQuery.of(context).size.width * 0.062,
                              height: MediaQuery.of(context).size.height * 0.029, color: Color(0xff7898FF),),
                            content: Text('${infocontent}',
                              style: TextStyle(
                                fontSize: isSmallScreen?10:12,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),)
                    ));
              },
            );
          },
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

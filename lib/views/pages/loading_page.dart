import 'package:flutter/material.dart';
import '../../apis.dart';



class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            FutureBuilder(
              future: APIs.getMatchingData(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.hasData == false) {
                    //받아오는 동안
                    return Container(
                        margin: EdgeInsets.only(left: 75));
                  }
                  else
                    //받아온 후
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/main', (Route<dynamic> route) => false,
                          arguments: snapshot.data);
                    });
                    return Container(
                        margin: EdgeInsets.only(left: 75),
                        child: Image(image: AssetImage("assets/illustration/loading_01.gif")));
            })

      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    //여러가지 해봤는데 easeInOutBack이 제일 스무스해 보였어요
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOutBack);

    controller.repeat(reverse: true);

    controller.addListener(() {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(() {
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 30,
              decoration: BoxDecoration(color: Colors.grey.shade400),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 40,
              decoration: BoxDecoration(color: Colors.grey.shade400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 200,
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                            width: 65,
                            height: 80,
                            decoration:
                                BoxDecoration(color: Colors.grey.shade100),
                          ),
                          bottom: animation.value * 30 + 20,
                          left: 0,
                          right: 0,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                            width: 65,
                            height: 80,
                            decoration:
                                BoxDecoration(color: Colors.grey.shade100),
                          ),
                          bottom: animation.value * 50 + 20, //이 값을 다양하게 변형
                          left: 0,
                          right: 0,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                            width: 65,
                            height: 80,
                            decoration:
                                BoxDecoration(color: Colors.grey.shade100),
                          ),
                          bottom: animation.value * -50 + 60,
                          left: 0,
                          right: 0,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 10,
              decoration: BoxDecoration(color: Colors.grey.shade400),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 30,
              decoration: BoxDecoration(color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}

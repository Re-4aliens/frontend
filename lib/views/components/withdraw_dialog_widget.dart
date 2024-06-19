import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class WithdrawDialog extends StatelessWidget {
  final bool correct;

  const WithdrawDialog({Key? key, required this.correct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return androidDialog();
    } else {
      return iOSDialog();
    }
  }

  Widget androidDialog() {
    return Container();
  }

  Widget iOSDialog() {
    return Container();
  }
}

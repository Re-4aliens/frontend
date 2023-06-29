import 'package:aliens/mockdatas/mockdata_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/message_model.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({super.key});

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 150,
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(context: context,
                      builder: (builder) =>
                          Dialog(
                            elevation: 0,
                            backgroundColor: Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              height: 570,
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 17,
                                      child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(30.0),
                                          child: Text("신고하기", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        ),
                                        for(int i = 0; i < 5; i++)
                                          RadioListTile(
                                            title: Text('스팸/사기'),
                                            value: 'SPAM',
                                            groupValue: '',
                                            onChanged: (value) {
                                              setState(() {
                                                //selectedOption = value;
                                              });
                                            },
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 2,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0)
                                              ),
                                              hintText: '신고 사유를 입력해주세요.',
                                            ),
                                            validator: (value) {
                                              if (value!.trim().isEmpty) {
                                                return '신고 사유를 입력해주세요.';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],)),
                                  Divider(height: 2,),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Expanded(child: InkWell(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          child: Center(
                                              child: Text("취소")),
                                          onTap: (){},
                                        )),
                                        VerticalDivider(width: 2,),
                                        Expanded(child: InkWell(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          child: Center(child: Text("차단하기",style: TextStyle(fontWeight: FontWeight.bold))),
                                          onTap: (){},
                                        )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                },
                child: Column(children: [
                  Expanded(flex: 2, child: SizedBox()),
                  Text(
                    "신고하기",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                ]),
              ),
            ),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(context: context,
                      builder: (builder) =>
                          Dialog(
                            elevation: 0,
                            backgroundColor: Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              height: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("사용자를 차단하시겠습니까?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                          SizedBox(height: 10,),
                                          Text("메세지 수신 및 발신이 모두 차단되며,\n차단된 상대방과는 재매칭이 불가합니다.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14),),
                                        ],
                                      )),
                                  Divider(height: 2,),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Expanded(child: InkWell(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          child: Center(
                                              child: Text("취소")),
                                          onTap: (){},
                                        )),
                                        VerticalDivider(width: 2,),
                                        Expanded(child: InkWell(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          child: Center(child: Text("차단하기",style: TextStyle(fontWeight: FontWeight.bold))),
                                          onTap: (){},
                                        )),
                                      ],
                                    ),
                                  )


                                ],
                              ),
                            ),
                          ));
                },
                child: Column(children: [
                  Expanded(flex: 1, child: SizedBox()),
                  Text(
                    "차단하기",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(flex: 2, child: SizedBox()),
                ]),
              ),
            ),],
        ),
      ),
    );
  }

}

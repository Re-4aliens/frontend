import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (builder) => Dialog(
                            elevation: 0,
                            backgroundColor: const Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: SizedBox(
                              height: 570,
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 17,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(30.0),
                                            child: Text(
                                              "신고하기",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          for (int i = 0; i < 5; i++)
                                            RadioListTile(
                                              title: const Text('스팸/사기'),
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
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 2,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0)),
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
                                        ],
                                      )),
                                  const Divider(
                                    height: 2,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          child:
                                              const Center(child: Text("취소")),
                                          onTap: () {},
                                        )),
                                        const VerticalDivider(
                                          width: 2,
                                        ),
                                        Expanded(
                                            child: InkWell(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          child: const Center(
                                              child: Text("차단하기",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          onTap: () {},
                                        )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                },
                child: Column(children: const [
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (builder) => Dialog(
                            elevation: 0,
                            backgroundColor: const Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: SizedBox(
                              height: 180,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "사용자를 차단하시겠습니까?",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "메세지 수신 및 발신이 모두 차단되며,\n차단된 상대방과는 재매칭이 불가합니다.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      )),
                                  const Divider(
                                    height: 2,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          child:
                                              const Center(child: Text("취소")),
                                          onTap: () {},
                                        )),
                                        const VerticalDivider(
                                          width: 2,
                                        ),
                                        Expanded(
                                            child: InkWell(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          child: const Center(
                                              child: Text("차단하기",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          onTap: () {},
                                        )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                },
                child: Column(children: const [
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
            ),
          ],
        ),
      ),
    );
  }
}

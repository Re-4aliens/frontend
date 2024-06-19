import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:aliens/services/apis.dart';

class iOSReportDialog extends StatefulWidget {
  const iOSReportDialog({
    super.key,
    required this.memberId,
  });
  final int memberId;

  @override
  State<iOSReportDialog> createState() => _iOSReportDialogState();
}

class _iOSReportDialogState extends State<iOSReportDialog> {
  List<List<String>> reportList = [
    ["SEXUAL_HARASSMENT", 'chatting-report2'.tr()],
    ["VIOLENCE", 'chatting-report3'.tr()],
    ["SPAM", 'chatting-report4'.tr()],
    ["SCAM", 'chatting-report5'.tr()],
    ["ETC", 'chatting-report6'.tr()]
  ];
  final TextEditingController _textEditingController =
      TextEditingController(text: ' ');

  String? _reportReason = 'chatting-report2'.tr();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0).w,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 40.h, horizontal: 40.w),
                        child: Text(
                          "chatting-report1".tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                    ListTile(
                      title: Text(reportList[0][1]),
                      leading: Radio<String>(
                        value: reportList[0][1],
                        groupValue: _reportReason,
                        onChanged: (String? value) {
                          setState(() {
                            _reportReason = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(reportList[1][1]),
                      leading: Radio<String>(
                        value: reportList[1][1],
                        groupValue: _reportReason,
                        onChanged: (String? value) {
                          setState(() {
                            _reportReason = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(reportList[2][1]),
                      leading: Radio<String>(
                        value: reportList[2][1],
                        groupValue: _reportReason,
                        onChanged: (String? value) {
                          setState(() {
                            _reportReason = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(reportList[3][1]),
                      leading: Radio<String>(
                        value: reportList[3][1],
                        groupValue: _reportReason,
                        onChanged: (String? value) {
                          setState(() {
                            _reportReason = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(reportList[4][1]),
                      leading: Radio<String>(
                        value: reportList[4][1],
                        groupValue: _reportReason,
                        onChanged: (String? value) {
                          setState(() {
                            _reportReason = value;
                            print('$_reportReason');
                          });
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFD2D2D2), width: 1.w),
                      ),
                      margin: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 10)
                          .r,
                      padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0)
                          .r,
                      child: TextFormField(
                        controller: _textEditingController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'chatting-report7'.tr(),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 60.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      child: Center(child: Text('cancle'.tr())),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  VerticalDivider(
                    width: 2.w,
                  ),
                  Expanded(
                    child: InkWell(
                      child: Center(child: Text("chatting-report1".tr())),
                      onTap: () async {
                        String reportCategory = '';
                        for (int i = 0; i < reportList.length; i++) {
                          if (reportList[i][1] == _reportReason) {
                            reportCategory = reportList[i][0];
                            break;
                          }
                        }
                        if (await APIs.reportPartner(reportCategory,
                            _textEditingController.text, widget.memberId)) {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'chatting-report8'.tr(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

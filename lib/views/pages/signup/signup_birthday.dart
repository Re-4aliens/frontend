import 'package:aliens/views/components/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/button.dart';
import 'package:intl/intl.dart';

class SignUpBirthday extends StatefulWidget{
  const SignUpBirthday({super.key});

  @override
  State<SignUpBirthday> createState() => _SignUpBirthdayState();
}

class _SignUpBirthdayState extends State<SignUpBirthday>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _BirthdayController = TextEditingController();
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  bool _isButtonEnabled = false;

  Widget build(BuildContext context){
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(appBar: AppBar(), title: '',  backgroundColor: Colors.white, infookay: false, infocontent: '',),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('signup-birthday'.tr(),
              style: TextStyle(fontSize: 24.spMin, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
             Form(
               key: _formKey,
               child: GestureDetector(
                 onTap: (){
                   HapticFeedback.mediumImpact();
                   _selectDate();
                 },
                 child: Column(
                   children: [
                     TextFormField(
                       decoration: new InputDecoration(
                           hintText: 'birthday'.tr(),
                           suffixIcon: IconButton(
                             icon: SvgPicture.asset(
                               'assets/icon/icon_dropdown.svg',
                               width: MediaQuery.of(context).size.width * 0.037,
                               height: MediaQuery.of(context).size.height * 0.011,
                             ), onPressed: () {},
                           ),
                           hintStyle: TextStyle(fontSize: isSmallScreen ? 18:20, color: Color(0xffD9D9D9))
                       ),
                       validator : (value) => value!.isEmpty? "Please enter some text" : null,
                       enabled: false,
                       controller: _BirthdayController,
                     )
                   ]
                 ),
               )
               ),
            Expanded(child: SizedBox()),
            Button(
              //수정
                isEnabled: _isButtonEnabled,
                child: Text('confirm'.tr(), style: TextStyle( color: _isButtonEnabled? Colors.white : Color(0xff888888))),
                onPressed: (){
                  if(_isButtonEnabled){
                    member.birthday = _BirthdayController.text;
                    print(member.toJson());
                    Navigator.pushNamed(context,'/gender', arguments: member);
                  }
                })
          ],
        ),
      ),
    );
  }
  _selectDate() async{
    DateTime? pickedDate =  await showModalBottomSheet<DateTime>(
      context: context,
      builder:  (context){
        return Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: Text('cancel'.tr()),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: Text('done'.tr()),
                        onPressed: (){
                          Navigator.of(context).pop(tempPickedDate);
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: Container(
                    child: CupertinoDatePicker(
                      minimumYear: 1950,
                      maximumYear: DateTime.now().year - 14,
                      initialDateTime: DateTime.parse("${DateTime.now().year - 14}-01-01"),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime dateTime){
                        tempPickedDate = dateTime;
                      },
                    ),
                  ),
                ),
              ],
            )
        );
      },
    );
    if(pickedDate != null && pickedDate != _selectedDate){
      setState((){
        _selectedDate = pickedDate;
        _BirthdayController.text = pickedDate.toString();
        convertDateTimeDisplay(_BirthdayController.text);
        _isButtonEnabled = true;
      });
    }
  }
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    return _BirthdayController.text = serverFormater.format(displayDate);
  }
}

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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

  Widget build(BuildContext context){
    //var members = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('생년월일을 알려주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 40),
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
                           hintText: '생년월일 선택',
                           suffixIcon: Icon(Icons.arrow_drop_down),
                           hintStyle: TextStyle(fontSize: 20, color: Color(0xffD9D9D9))
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
                child: Text('확인'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pushNamed(context,'/gender', /*arguments: members*/);
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
                        child: Text('취소'),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: Text('완료'),
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
                      maximumYear: DateTime.now().year,
                      initialDateTime: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime dateTime){
                        tempPickedDate = dateTime;
                      },
                    ),
                  ),
                )
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

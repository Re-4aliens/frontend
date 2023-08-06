import 'dart:convert';
import 'package:dash_flags/dash_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:aliens/main.dart';
import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/countries.dart';
import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpNationality extends StatefulWidget {
  const SignUpNationality({super.key});

  @override
  State<SignUpNationality> createState() => _SignUpNationalityState();
}

/*List<dynamic> nationList = [];*/

class _SignUpNationalityState extends State<SignUpNationality> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _NationalityController = new TextEditingController();
  var _selectedNationality = '';
  String? tempPickedCountry = "Afghanistan";
  bool _isButtonEnabled = false;

  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;


    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: Colors.white, infookay: false, infocontent: '',
      ),
      body: Padding(
        padding: EdgeInsets.only(
            right: 24,
            left: 24,
            top: MediaQuery.of(context).size.height * 0.06,
            bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'signup-nationality'.tr(),
              style: TextStyle(
                  fontSize: isSmallScreen?22:24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Form(
                key: _formKey,
                child: GestureDetector(
                  onTap: (){
                    HapticFeedback.mediumImpact();
                    _selectCountry();
                  },
                  child: Column(
                      children: [
                        TextFormField(
                          decoration: new InputDecoration(
                              hintText: 'nationality'.tr(),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(alignment: Alignment.centerRight, width: 180, child: Text("${_selectedNationality}", style: TextStyle(fontSize: isSmallScreen? 16:20, fontWeight: FontWeight.bold),)),
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/icon/icon_dropdown.svg',
                                      width: MediaQuery.of(context).size.width * 0.037,
                                      height: MediaQuery.of(context).size.height * 0.011,
                                    ), onPressed: () {},
                                  ),
                                ],
                              ),
                              hintStyle: TextStyle(fontSize: isSmallScreen?14:16, color: Colors.black)
                          ),
                          //validator : (value) => value!.isEmpty? "Please enter some text" : null,
                          enabled: false,
                        )
                      ]
                  ),
                )
            ),
            Divider(
              height: 0,
              thickness: 1,
            ),
            Expanded(child: SizedBox()),
            Button(
                isEnabled: _isButtonEnabled,
                child: Text('confirm'.tr(), style: TextStyle( color: _isButtonEnabled? Colors.white : Color(0xff888888))),
                onPressed: () {
                  if(_isButtonEnabled){

                      member.nationality = _selectedNationality;
                      print(member.toJson());
                      Navigator.pushNamed(context, '/mbti', arguments: member);
                    }
                  })
          ],
        ),
      )
    );
  }
  _selectCountry() async{
    String? pickedCountry = await showModalBottomSheet<String>(
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
                          Navigator.of(context).pop(tempPickedCountry);
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
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      itemExtent: 30,
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          tempPickedCountry = countries[selectedItem]['name'];
                        });
                      },
                      children:
                      List<Widget>.generate(countries.length, (int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(flex: 1, child: Container(
                              alignment: Alignment.center,
                              width: 30,
                              child: CountryFlag(
                                country: Country.fromCode('${countries[index]['code']}'),
                                height: 20,
                              ),
                            ),),
                            Expanded(flex: 1, child: Text('${countries[index]['name']}', overflow: TextOverflow.ellipsis, softWrap: true,)),
                          ],
                        );
                      }),
                    )
                ),
              ],
            )
        );
      },
    );
    if(pickedCountry != null && pickedCountry != _selectedNationality){
      setState((){
        _selectedNationality = pickedCountry;
        _isButtonEnabled = true;
      });
    }
  }
}
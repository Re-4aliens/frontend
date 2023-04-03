import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

import 'package:country_picker/country_picker.dart';

class SignUpNationality extends StatefulWidget {
  const SignUpNationality({super.key});

  @override
  State<SignUpNationality> createState() => _SignUpNationalityState();
}

class _SignUpNationalityState extends State<SignUpNationality> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _NationalityController =
      new TextEditingController();
  var _selectedNationality = '';

  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        onPressed: () {},
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '국적을 알려주세요',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            InkWell(
              key: _formKey,
              onTap: () {
                showCountryPicker(
                    context: context,
                    showPhoneCode:false,
                    onSelect: (Country country) {
                      print('Select country: ${country.displayName}');
                      setState(() {
                        var countryName = country.displayName.toString();
                        countryName = countryName.substring(0, countryName.indexOf(' '));
                        _selectedNationality = countryName;
                      });
                    });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '국적',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _selectedNationality,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
            ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('확인'),
                onPressed: () {
                  if(_selectedNationality != ''){
                    member.nationality = _selectedNationality;
                    print(member.toJson());
                    Navigator.pushNamed(
                        context,
                        '/mbti', arguments: member
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}

// @dart=2.9
import 'package:bi_whitenoise/data/color.dart';
import 'package:bi_whitenoise/pages/player.dart';
import 'package:bi_whitenoise/src/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

enum Gender { MAN, WOMEN }

class _UserInfoFormState extends State<UserInfoForm> {
  final _userController = Get.put(UserController());

  final year = DateTime.now().year;

  String _birthDay;

  TextEditingController _bymdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Gender _gender = Gender.MAN;

  @override
  void initState() {
    print(_userController.userProfile.value.birth);

    setState(() {
      if (_userController.userProfile.value != null) {
        _birthDay = _userController.userProfile.value.birth;

        _bymdController.text = _birthDay;

        if (_userController.userProfile.value.gender == 'Gender.MAN') {
          _gender = Gender.MAN;
        } else {
          _gender = Gender.WOMEN;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _bymdController.dispose();
    super.dispose();
  }

  birthDatePicker() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                datePickBtn(
                  text: 'cancel',
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                datePickBtn(
                  text: 'save',
                  color: ColorData.primaryColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 3.0,
              width: MediaQuery.of(context).size.width,
              child: CupertinoDatePicker(
                backgroundColor: Colors.white,

                minimumYear: year - 100,
                maximumYear: DateTime.now().year,
                initialDateTime: DateTime.now(),
                // initialDateTime: DateFormat('yyyy-MM-dd').parse(initDateStr ?? '2000-01-01'),

                maximumDate: DateTime.now(),
                onDateTimeChanged: (dateTime) {
                  print(dateTime);
                  _bymdController.text = dateTime.toString().split(' ')[0];
                  _userController
                      .updateBirth(dateTime.toString().split(' ')[0]);
                },
                mode: CupertinoDatePickerMode.date,
              ),
            ),
          );
        });
  }

  Widget _getUserProfile() {
    return GetBuilder<UserController>(builder: (_) {
      print('${_.userProfile.value}');
      return Text(
        '생년월일: ${_.userProfile.value.birth}\n 성별: ${_userController.userProfile.value.gender.split('.')[1] == 'MAN' ? '남성' : '여성'} ',
      );
    });
  }

  Widget _textBirthFieldWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.0,
          ),

          // birthDate
          Card(
            // tap에 반응하기위해 GestureDetector 사용z
            child: GestureDetector(
              onTap: () {
                print('tap!');
                birthDatePicker();
              },
              child: AbsorbPointer(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: TextFormField(
                    controller: _bymdController,
                    validator: (value) {
                      // error message
                      if (value.isEmpty)
                        return '생년월일을 선택해주세요.';
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                      labelText: '생년월일',
                      border: InputBorder.none,
                      filled: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // gender check radio widget
          _genderRadioWidget(),
          OutlinedButton(
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                Get.snackbar('필수항목', '생년월일을 선택해주세요',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.white);
              } else {
                Get.defaultDialog(
                  title: '정보가 맞습니까?',
                  content: Column(
                    children: [
                      _getUserProfile(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          datePickBtn(
                            text: '수정',
                            color: ColorData.primaryColor,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          datePickBtn(
                            text: '저장',
                            color: ColorData.primaryColor,
                            onPressed: () {
                              Get.back();
                              Get.to(
                                PlayerPage(),
                                transition: Transition.fadeIn,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
                _userController.save();
              }
            },
            child: Text(
              '저장',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderRadioWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Card(
            color: ColorData.bgColor,
            elevation: 0,
            child: RadioListTile<Gender>(
              activeColor: ColorData.primaryColor,
              title: Text(
                '남자',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              value: Gender.MAN,
              groupValue: _gender,
              onChanged: (Gender value) {
                setState(() {
                  _gender = value;
                  _userController.updateGender(value.toString());
                });
              },
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Card(
            color: ColorData.bgColor,
            elevation: 0,
            child: RadioListTile<Gender>(
              activeColor: ColorData.primaryColor,
              title: Text(
                '여자',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              value: Gender.WOMEN,
              groupValue: _gender,
              onChanged: (Gender value) {
                setState(() {
                  _gender = value;
                  _userController.updateGender(value.toString());
                });
              },
            ),
          ),
        ),
      ],
    );
  }

// 사용자에게 안내해주기 -> 정확한 정보입력하도록 유도, 전문적인 컨텐츠를 준다는 느낌을 주도록
// 청취자에게 보다 높은 정확도의 음원을 제공해줄수있다고 알려주기
// 청취자의 정확한 발달기준을 측정하여 보다 높은 정확도의 음원을 제공하고자 합니다.
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '\n높은 정확도의 음원을 제공해드리기위해\n 추가 정보를 입력받고 있습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        _textBirthFieldWidget(),
      ],
    );
  }
}

Widget datePickBtn({String text = "", color, onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    ),
  );
}

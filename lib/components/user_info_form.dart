// @dart=2.9
import 'dart:async';

import 'package:bi_whitenoise/data/color.dart';
import 'package:bi_whitenoise/src/user_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

enum Gender { MAN, WOMEN }
// enum Listener { Child, Me }

class _UserInfoFormState extends State<UserInfoForm> {
  bool _loading = true;

  final _userController = Get.put(UserController());

  final year = DateTime.now().year;

  TextEditingController _bymdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // final _selectFormKey = GlobalKey<FormState>();

  Gender _gender;

  Timer _timer;

  bool _selected = false;

  List<Listener> listeners;

  Listener _listener;

  bool _pagePrev = true;

  bool _isdisabled = true;

  @override
  void initState() {
    print(_userController.userProfile.value.birth);

// setState(() {
//   Future.delayed(Duration(seconds: 1),(){
//         _loading = false;
//   });
// });

// enum Listener { Child, Me }
    listeners = [Listener("아이", false), Listener("본인", false)];
    // listeners.add(new Listener("아이", false));
    // listeners.add(new Listener("본인", false));

    // if (mounted) {
    //   _timer = Timer(Duration(seconds: 2), () {
    //     setState(() {
    //       _loading = false;
    //     });
    //   });
    //   // _gender = Gender.MAN;
    //   // _userController.updateGender(Gender.MAN.toString());
    // }

    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     _loading = false;
    //   });
    // });
    setState(() {
      _loading = false;
    });
    // if (_userController.userProfile.value.birth.length > 2) {
    //   _birthDay = _userController.userProfile.value.birth;

    //   _bymdController.text = _birthDay;

    //   if (_userController.userProfile.value.gender == 'Gender.MAN') {
    //     _gender = Gender.MAN;
    //   } else {
    //     _gender = Gender.WOMEN;
    //   }
    // }

    super.initState();
  }

  @override
  void dispose() {
    _bymdController.dispose();
    super.dispose();
    // _timer.cancel();
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
        '사용자: ${_.userProfile.value.listener == 'me' ? '본인' : '아이'}\n생년월일: ${_.userProfile.value.birth}\n성별: ${_userController.userProfile.value.gender.split('.')[1] == 'MAN' ? '남성' : '여성'} ',
      );
    });
  }

  Widget customListenerSelect(_listener) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: _listener.isSelected ? ColorData.primaryColor : Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          // height: 80,
          // width: 80,

          alignment: Alignment.center,
          margin: new EdgeInsets.all(60.0),
          child: Text(
            _listener.name,
            style: TextStyle(
                fontSize: 20,
                color: _listener.isSelected ? Colors.white : Colors.black),
          ),
        ));
  }

  Widget _textBirthFieldWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _pagePrev = true;
                    });
                  },
                  child: Text(
                    '이전',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MontserratExtraBold',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  )),
              Text(
                'MySound    ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MontserratExtraBold',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(
            height: 50.0,
          ),
          Text(
            '\n정확한 음원제공을 위해\n사용자 정보를 입력해주세요.(2/2)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          // Listener Select Widget

          SizedBox(height: 60),
          Text(
            '기본정보를 입력해주세요',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // birthDate
          Card(
            // tap에 반응하기위해 GestureDetector 사용
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
          SizedBox(
            height: 10.0,
          ),
          _submitBtn(
            text: "저장",
            color: Colors.white,
            bgColor: _isdisabled ? Colors.grey : ColorData.primaryColor,
            onPressed: _isdisabled
                ? null
                : () {
                    if (!_formKey.currentState.validate()) {
                      Get.snackbar('필수항목', '생년월일을 선택해주세요',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white);
                    } else if (_gender == null) {
                      Get.snackbar('필수항목', '성별을 선택해주세요',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white);
                    } else {
                      Get.defaultDialog(
                        title: '정보가 맞습니까?',
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
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
                                    _userController.save();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                      // _userController.save();
                    }
                    // setState(() {
                    //   _pagePrev = false;
                    // });
                  },
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

// se;ectListner RadioButton Widget
  Widget _selectListenerWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'MySound',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MontserratExtraBold',
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        SizedBox(height: 50),
        Text(
          '\n정확한 음원제공을 위해\n사용자 정보를 입력해주세요.(1/2)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        // Listener Select Widget

        SizedBox(height: 60),
        Text(
          '누가 사용하나요',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),

        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 16),
            InkWell(
              child: customListenerSelect(listeners[0]),
              onTap: () {
                setState(() {
                  listeners.forEach((listener) => listener.isSelected = false);
                  listeners[0].isSelected = true;
                  // _isdisabled = !_isdisabled;
                  _isdisabled = false;
                });
                _userController.updateListener("child");
                print(_userController.userProfile.value.listener);
              },
            ),
            SizedBox(width: 15),
            InkWell(
              child: customListenerSelect(listeners[1]),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              onTap: () {
                setState(() {
                  listeners.forEach((listener) => listener.isSelected = false);
                  listeners[1].isSelected = true;
                  // _isdisabled = !_isdisabled;
                  _isdisabled = false;
                });
                _userController.updateListener("me");
                print(_userController.userProfile.value.listener);
              },
            ),
            SizedBox(width: 16),
          ],
        ),
        SizedBox(height: 50),
        _submitBtn(
          text: "다음",
          color: Colors.white,
          bgColor: _isdisabled ? Colors.grey : ColorData.primaryColor,
          onPressed: _isdisabled
              ? null
              : () {
                  setState(() {
                    _pagePrev = false;
                  });
                },
        ),
        // _textBirthFieldWidget(),
      ],
    );
  }

// 사용자에게 안내해주기 -> 정확한 정보입력하도록 유도, 전문적인 컨텐츠를 준다는 느낌을 주도록
// 청취자에게 보다 높은 정확도의 음원을 제공해줄수있다고 알려주기
// 청취자의 정확한 발달기준을 측정하여 보다 높은 정확도의 음원을 제공하고자 합니다.
  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : _pagePrev
            ? _selectListenerWidget()
            : _textBirthFieldWidget();
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

Widget listenerSelectBtn({String text = "", color, onPressed}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.all(70),
      backgroundColor: Colors.white,
    ),
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

Widget selectBtn({String text = "", color, onPressed}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.all(70),
      backgroundColor: Colors.white,
    ),
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

Widget _submitBtn({String text = "", color, bgColor, onPressed}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 160, vertical: 20),
      backgroundColor: bgColor,
    ),
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

class Listener {
  String name;
  bool isSelected;

  Listener(this.name, this.isSelected);
}

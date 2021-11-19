import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Models/UserStatsModel.dart';
import 'package:curious_room/Views/Style/screenStyle.dart';
import 'package:curious_room/Views/Style/textStyle.dart';
import 'package:flutter/material.dart';

var listIconUser = [
  'Q_Icon.png',
  'A_Icon.png',
  'correct_icon.png',
  'score_icon.png'
];
var listTypeUser = ['ถาม', 'ตอบ', 'คำตอบที่ดีที่สุด', 'คะแนนที่ได้รับ'];
var listIconAdmin = ['declare_Icon.png'];
var listTypeAdmin = ['ประกาศ'];
var listIcon;
var listType;

late UserStatsModel? value;

void checkRole(UserModel userModel) {
  if (userModel.role == 'USER') {
    listIcon = listIconUser;
    listType = listTypeUser;
  } else {
    listIcon = listIconAdmin;
    listType = listTypeAdmin;
  }
}

checkOwner(UserModel userModel, UserModel? usermodel) {
  return userModel.id == usermodel!.id ? true : false;
}

listScore(var future) {
  return FutureBuilder<UserStatsModel>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            '',
            style: TextStyle(color: Color.fromRGBO(176, 162, 148, 1.0)),
          );
        } else if (snapshot.hasData) {
          value = snapshot.data;
          var score = [
            value!.userPost,
            value!.userComment,
            value!.bestComment,
            value!.userVote
          ];
          return ListView.builder(
              padding: EdgeInsets.only(left: 20, top: 20, right: 30),
              shrinkWrap: true,
              itemCount: listType.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image(
                                  image: Image.asset(
                                          'assets/icons/${listIcon[index]}')
                                      .image),
                              SizedBox(
                                width: screenw(context, 0.04),
                              ),
                              Text('${listType[index]}',
                                  style: normalTextStyle(18)),
                            ],
                          ),
                          Row(children: [
                            Text('${score[index]}', style: normalTextStyle(18))
                          ])
                        ],
                      ),
                      SizedBox(
                        height: screenh(context, 0.01),
                      ),
                      Container(
                        height: 1.5,
                        width: screenw(context, 0.80),
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                      ),
                      SizedBox(
                        height: screenh(context, 0.02),
                      ),
                    ],
                  ),
                );
              });
        } else {
          return LinearProgressIndicator();
        }
      });
}

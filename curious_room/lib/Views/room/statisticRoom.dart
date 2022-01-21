// import 'dart:collection';
// import 'dart:convert';

import 'package:curious_room/Models/PostModel.dart';
import 'package:curious_room/Views/room/allStatistic.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key, required this.roomid}) : super(key: key);

  final int roomid;
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late Future<List<PostModel>> future = Future.value([]);
  late List<PostModel> value = [];
  @override
  void initState() {
    super.initState();
    print(widget.roomid);
    future = getStatistPost(widget.roomid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(107, 103, 98, 1),
          iconSize: 45,
        ),
        titleSpacing: 0,
        title: Text('สถิติ'),
        titleTextStyle: TextStyle(
            color: Color.fromRGBO(107, 103, 98, 1),
            fontSize: 19.sp,
            fontFamily: 'Prompt'),
        // elevation: 0,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.fromLTRB(
          5.w,
          1.h,
          5.w,
          1.h,
        ),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<List<PostModel>>(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.data.toString() == "[]") {
                        return Center(
                          child: Text(
                            'ยังไม่มีสถิติ',
                            style: TextStyle(
                                color: Color.fromRGBO(176, 162, 148, 1.0)),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        value = snapshot.data!;
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'โพสต์สูงสุด',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Color.fromRGBO(117, 195, 185, 1)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.orange),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: value.length <= 3
                                              ? value.length
                                              : 3,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      index == 0
                                                          ? Column(

                                                              // alignment:
                                                              //     Alignment
                                                              //         .topCenter,
                                                              children: [
                                                                  Image.asset(
                                                                    "assets/images/crown.png",
                                                                    scale: 10,
                                                                    height: 3.h,
                                                                  ),
                                                                  CircleAvatar(
                                                                    backgroundColor:
                                                                        Color.fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            0),
                                                                    radius:
                                                                        18.5,
                                                                    backgroundImage:
                                                                        Image.network((value[index].userPost.display).toString())
                                                                            .image,
                                                                  ),

                                                                  // CircleAvatar(
                                                                  //   backgroundColor:
                                                                  //       Color.fromRGBO(
                                                                  //           255,
                                                                  //           255,
                                                                  //           255,
                                                                  //           0),
                                                                  //   radius:
                                                                  //       18.5,
                                                                  //   backgroundImage:
                                                                  //       Image.asset("assets/images/crown.png")
                                                                  //           .image,
                                                                  // ),
                                                                ])
                                                          : CircleAvatar(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          0),
                                                              radius: 18.5,
                                                              backgroundImage: Image.network((value[
                                                                              index]
                                                                          .userPost
                                                                          .display)
                                                                      .toString())
                                                                  .image,
                                                            ),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Text(
                                                        value[index]
                                                            .userPost
                                                            .name,
                                                        style: mycolor(17.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    value[index]
                                                        .statist
                                                        .toString(),
                                                    style: mycolor(17.sp),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                    TextButton(
                                        child: Text(
                                          'ดูทั้งหมด',
                                          style: mycolor(15.sp),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllStatistic(
                                                          header: "โพสต์สูงสุด",
                                                          future: future)));
                                        })
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                            )
                          ],
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }))
          ],
        ),
      )),
    );
  }

  TextStyle mycolor(double s) {
    return TextStyle(color: Colors.white, fontSize: s);
  }
}

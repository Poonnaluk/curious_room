// import 'dart:collection';
// import 'dart:convert';

import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/Views/room/allStatistic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key, required this.roomid}) : super(key: key);

  final int roomid;
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late Future<List<RoomModel>> futurePost = Future.value([]);
  late Future<List<RoomModel>> futureAns = Future.value([]);
  late List<RoomModel> value = [];
  late List<RoomModel> valueAns = [];
  late List<RoomModel> _chartData = [];
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    super.initState();
    getChart(widget.roomid).then((value) {
      setState(() {
        _chartData = value;
      });
    });
    print(_chartData);
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      shared: true,
    );
    // print(widget.roomid);
    futurePost = getStatistPost(widget.roomid);
    futureAns = getStatistAns(widget.roomid);
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
            Flexible(
              // height: 30.h,
              child: SfCartesianChart(
                tooltipBehavior: _tooltipBehavior,
                series: <ChartSeries>[
                  // Renders bar chart
                  BarSeries<RoomModel, String>(
                      width: 0.6,
                      // spacing: 0.3,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      // borderWidth: 30,
                      name: "คะแนน",
                      color: Color.fromRGBO(69, 171, 157, 1),
                      dataSource: _chartData,
                      xValueMapper: (RoomModel gdp, _) => gdp.userPost!.name,
                      yValueMapper: (RoomModel gdp, _) =>
                          int.parse(gdp.mostLike!),
                      dataLabelSettings: DataLabelSettings(
                          // showZeroValue: true,
                          isVisible: true,
                          showCumulativeValues: true),
                      enableTooltip: true),
                ],
                title: ChartTitle(
                    text: "คะแนนโหวตสูงสุด",
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      // fontWeight: FontWeight.w600,
                      // color: Color.fromRGBO(117, 195, 185, 1)
                    )),
                enableAxisAnimation: true,
                primaryXAxis: CategoryAxis(
                  visibleMaximum: 2,
                  maximumLabelWidth: 60,
                  // labelPosition: ChartDataLabelPosition.outside,
                  title:
                      AxisTitle(text: "ลำดับ", alignment: ChartAlignment.far),
                  //Hide the gridlines of y-axis
                  majorGridLines: MajorGridLines(width: 0),
                  //Hide the axis line of y-axis
                  axisLine: AxisLine(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  title:
                      AxisTitle(text: "คะแนน", alignment: ChartAlignment.far),
                  majorGridLines: MajorGridLines(width: 0),
                  axisLine: AxisLine(width: 0),
                  // edgeLabelPlacement: EdgeLabelPlacement.shift,
                  // numberFormat: NumberFormat.simpleCurrency(

                  //   decimalDigits: 0,
                  // ),
                  // title: AxisTitle(text: ''),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'โพสต์สูงสุด',
                style: TextStyle(
                    fontSize: 18.sp, color: Color.fromRGBO(117, 195, 185, 1)),
              ),
            ),
            Flexible(
                // height: 32.h,
                child: FutureBuilder<List<RoomModel>>(
                    future: futurePost,
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
                                                title: index == 0
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(children: [
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
                                                                  radius: 16.5,
                                                                  backgroundImage:
                                                                      Image.network(
                                                                              (value[index].userPost!.display).toString())
                                                                          .image,
                                                                ),
                                                              ]),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 2.w,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                20),
                                                                    child: Text(
                                                                      value[index]
                                                                          .userPost!
                                                                          .name,
                                                                      style: mycolor(
                                                                          15.sp),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 20),
                                                            child: Text(
                                                              value[index]
                                                                  .statist
                                                                  .toString(),
                                                              style: mycolor(
                                                                  15.sp),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            0),
                                                                radius: 16.5,
                                                                backgroundImage:
                                                                    Image.network(
                                                                            (value[index].userPost!.display).toString())
                                                                        .image,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 2.w,
                                                                  ),
                                                                  Text(
                                                                    value[index]
                                                                        .userPost!
                                                                        .name,
                                                                    style: mycolor(
                                                                        15.sp),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            value[index]
                                                                .statist
                                                                .toString(),
                                                            style:
                                                                mycolor(15.sp),
                                                          ),
                                                        ],
                                                      ));
                                          }),
                                    ),
                                    TextButton(
                                        child: Text(
                                          'ดูทั้งหมด',
                                          style: mycolor(13.sp),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllStatistic(
                                                          header: "โพสต์สูงสุด",
                                                          future: futurePost)));
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    })),
            SizedBox(
              height: 2.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'คำตอบที่ดีที่สุด',
                style: TextStyle(
                    fontSize: 18.sp, color: Color.fromRGBO(117, 195, 185, 1)),
              ),
            ),
            Flexible(
                // height: 32.h,
                child: FutureBuilder<List<RoomModel>>(
                    future: futureAns,
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
                        valueAns = snapshot.data!;
                        return Column(
                          children: [
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
                                          itemCount: valueAns.length <= 3
                                              ? valueAns.length
                                              : 3,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                                title: index == 0
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(children: [
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
                                                                  radius: 16.5,
                                                                  backgroundImage:
                                                                      Image.network(
                                                                              (valueAns[index].userComment!.display).toString())
                                                                          .image,
                                                                ),
                                                              ]),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 2.w,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                20),
                                                                    child: Text(
                                                                      valueAns[
                                                                              index]
                                                                          .userComment!
                                                                          .name,
                                                                      style: mycolor(
                                                                          15.sp),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 20),
                                                            child: Text(
                                                              valueAns[index]
                                                                  .statist
                                                                  .toString(),
                                                              style: mycolor(
                                                                  15.sp),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            0),
                                                                radius: 16.5,
                                                                backgroundImage:
                                                                    Image.network(
                                                                            (valueAns[index].userComment!.display).toString())
                                                                        .image,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 2.w,
                                                                  ),
                                                                  Text(
                                                                    valueAns[
                                                                            index]
                                                                        .userComment!
                                                                        .name,
                                                                    style: mycolor(
                                                                        15.sp),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            valueAns[index]
                                                                .statist
                                                                .toString(),
                                                            style:
                                                                mycolor(15.sp),
                                                          ),
                                                        ],
                                                      ));
                                          }),
                                    ),
                                    TextButton(
                                        child: Text(
                                          'ดูทั้งหมด',
                                          style: mycolor(13.sp),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllStatistic(
                                                          header:
                                                              "คำตอบที่ดีที่สุด",
                                                          future: futureAns)));
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    })),
          ],
        ),
      )),
    );
  }

  TextStyle mycolor(double s) {
    return TextStyle(color: Colors.white, fontSize: s);
  }

//   List<GDPData> getChartData() {
//     final List<GDPData> chartData = [
//       GDPData('Poonnaluk', 20),
//       GDPData('Siriwika', 15),
//       GDPData('Kamonchanok', 10),
//     ];
//     return chartData;
//   }
}

// class GDPData {
//   GDPData(this.continent, this.gdp);
//   final String continent;
//   final double gdp;
// }

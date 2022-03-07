// import 'dart:collection';
// import 'dart:convert';

import 'package:curious_room/Models/PostModel.dart';
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
  late Future<List<PostModel>> future = Future.value([]);
  late List<PostModel> value = [];
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    super.initState();
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      shared: true,
    );
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
            Container(
              height: 30.h,
              child: SfCartesianChart(
                tooltipBehavior: _tooltipBehavior,
                series: <ChartSeries>[
                  // Renders bar chart
                  BarSeries<GDPData, String>(
                      width: 0.6,
                      // spacing: 0.3,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      // borderWidth: 30,
                      name: "คะแนน",
                      color: Color.fromRGBO(69, 171, 157, 1),
                      dataSource: _chartData,
                      xValueMapper: (GDPData gdp, _) => gdp.continent,
                      yValueMapper: (GDPData gdp, _) => gdp.gdp,
                      dataLabelSettings: DataLabelSettings(
                          // showZeroValue: true,
                          isVisible: true,
                          showCumulativeValues: true),
                      enableTooltip: true),
                ],
                enableAxisAnimation: true,
                primaryXAxis: CategoryAxis(
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
                                                                  radius: 18.5,
                                                                  backgroundImage:
                                                                      Image.network(
                                                                              (value[index].userPost.display).toString())
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
                                                                          .userPost
                                                                          .name,
                                                                      style: mycolor(
                                                                          17.sp),
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
                                                                  17.sp),
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
                                                                radius: 18.5,
                                                                backgroundImage:
                                                                    Image.network(
                                                                            (value[index].userPost.display).toString())
                                                                        .image,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 2.w,
                                                                  ),
                                                                  Text(
                                                                    value[index]
                                                                        .userPost
                                                                        .name,
                                                                    style: mycolor(
                                                                        17.sp),
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
                                                                mycolor(17.sp),
                                                          ),
                                                        ],
                                                      ));
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
                            // SizedBox(
                            //   height: 40.h,
                            // )
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

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [
      GDPData('Poonnaluk', 20),
      GDPData('Siriwika', 15),
      GDPData('Kamonchanok', 10),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final double gdp;
}

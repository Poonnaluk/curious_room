import 'package:curious_room/Models/PostModel.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllStatistic extends StatefulWidget {
  const AllStatistic({required this.header, required this.future, Key? key})
      : super(key: key);

  final Future<List<PostModel>> future;
  final String header;
  @override
  _AllStatisticState createState() => _AllStatisticState();
}

class _AllStatisticState extends State<AllStatistic> {
  late List<PostModel> value = [];
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
          title: Text(widget.header),
          titleTextStyle: TextStyle(
              color: Color.fromRGBO(107, 103, 98, 1),
              fontSize: 19.sp,
              fontFamily: 'Prompt')),
      body: SafeArea(
        child: FutureBuilder<List<PostModel>>(
            future: widget.future,
            builder: (context, snapshot) {
              if (snapshot.data.toString() == "[]") {
                return Center(
                  child: Text(
                    'ยังไม่มีสถิติ',
                    style: TextStyle(color: Color.fromRGBO(176, 162, 148, 1.0)),
                  ),
                );
              } else if (snapshot.hasData) {
                value = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: value.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Color.fromRGBO(
                                                    255, 255, 255, 0),
                                                radius: 18.5,
                                                backgroundImage: Image.network(
                                                        (value[index]
                                                                .userPost
                                                                .display)
                                                            .toString())
                                                    .image,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Text(
                                                value[index].userPost.name,
                                                style: mycolor(17.sp),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            value[index].statist.toString(),
                                            style: mycolor(17.sp),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            // TextButton(
                            //     child: Text(
                            //       'ดูทั้งหมด',
                            //       style: mycolor(15.sp),
                            //     ),
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   AllStatistic(
                            //                       header: "โพสต์สูงสุด",
                            //                       future: future)));
                            //     })
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 50.h,
                    // )
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  TextStyle mycolor(double s) {
    return TextStyle(color: Colors.black, fontSize: s);
  }
}

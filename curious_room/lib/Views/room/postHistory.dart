import 'package:curious_room/Models/PostHistory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HistoryPage extends StatefulWidget {
  final int postid;
  const HistoryPage({Key? key, required this.postid}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<PostHistoryModel>> history = Future.value([]);
  late List<PostHistoryModel> value = [];
  @override
  void initState() {
    super.initState();
    history = getPostHistory(widget.postid);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
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
        title: Text('ประวัติการแก้ไข'),
        titleTextStyle: TextStyle(
            color: Color.fromRGBO(107, 103, 98, 1),
            fontSize: 19.sp,
            fontFamily: 'Prompt'),
        elevation: 0,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 1,
            color: Color.fromRGBO(124, 124, 124, 1),
          ),
          Expanded(
            child: FutureBuilder<List<PostHistoryModel>>(
              future: history,
              builder: (context, snapshot) {
                if (snapshot.data.toString() == "[]") {
                  return Center(
                    child: Text(
                      'ยังไม่มีการแก้ไข',
                      style:
                          TextStyle(color: Color.fromRGBO(176, 162, 148, 1.0)),
                    ),
                  );
                } else if (snapshot.hasData) {
                  value = snapshot.data!;
                  return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        String time = DateFormat('Hm')
                            .format(value[index].createdAt.toLocal());
                        String date =
                            '${DateFormat.yMMMd().format(value[index].createdAt.toLocal())}';
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
                                child: Row(
                                  children: [
                                    text(date),
                                    text(' เวลา '),
                                    text(time)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  value[index].content,
                                  style: TextStyle(fontSize: 17.5.sp),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                height: 1,
                                color: Color.fromRGBO(124, 124, 124, 1),
                              )
                            ],
                          ),
                        );
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      )),
    );
  }

  Text text(String t) => Text(
        t,
        style: TextStyle(
          color: Color.fromRGBO(124, 124, 124, 1),
        ),
      );
}

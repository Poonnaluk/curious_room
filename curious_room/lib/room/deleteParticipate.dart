import 'package:curious_room/Models/ParticipateModel.dart';
import 'package:curious_room/controllers/participateController.dart';
import 'package:curious_room/utility/alertDialog.dart';
import 'package:curious_room/utility/finishDialog.dart';
import 'package:flutter/material.dart';

class DeleteParticipate extends StatefulWidget {
  DeleteParticipate({Key? key, required this.roomid}) : super(key: key);
  final int roomid;

  @override
  _DeleteParticipateState createState() => _DeleteParticipateState();
}

class _DeleteParticipateState extends State<DeleteParticipate> {
  late double screenw;
  late double screenh;
  late Future<List<ParticipateModel>> future;
  late List<ParticipateModel>? value;
  ParticipateController controller = ParticipateController();

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    future = getParticipate(widget.roomid);
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            toolbarHeight: screenh * 0.08,
            title: new Text('ลบสมาชิก'),
            titleTextStyle: const TextStyle(
                color: Colors.black, fontSize: 24, fontFamily: 'Prompt'),
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () => Navigator.pop(context),
              color: Colors.black,
              iconSize: 50,
            ),
          ),
          body: SafeArea(
              child: Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenh * 0.03,
                          ),
                          Row(
                            children: [
                              Text(
                                "สมาชิก",
                                style: TextStyle(
                                    color: Color.fromRGBO(225, 141, 63, 1.0),
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenh * 0.008,
                          ),
                          Container(
                            height: 1.5,
                            color: Color.fromRGBO(69, 171, 157, 1.0),
                          ),
                          SizedBox(
                            height: screenh * 0.015,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                getParticipates(context),
                              ])
                        ],
                      )))));
    }
  }

  getParticipates(BuildContext context) {
    return FutureBuilder<List<ParticipateModel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.data.toString() == "[]") {
            return Text(
              'ยังไม่มีสมาชิก',
              style: TextStyle(color: Color.fromRGBO(176, 162, 148, 1.0)),
            );
          } else if (snapshot.hasData) {
            value = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: value!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      title: Row(children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/icons/delete_icon2.png',
                            height: 24.0,
                            width: 24.0,
                          ),
                          onPressed: () {
                            confirmDialog(context,
                                    'เมื่อลบผู้เข้าร่วม ${value?[index].userParticipate?.name} แล้วผู้ใช้นี้จะไม่สามารถมีส่วนร่วมในห้องนี้อีกต่อไป')
                                .then((data) async {
                              print('value >> $data');
                              if (data == 'true') {
                                CircularProgressIndicator();
                                await controller.deleteParicipate(widget.roomid,
                                    value![index].userParticipate!.id);
                                successDialog(context, 'ลบสมาชิกสำเร็จ');
                                refreshData();
                                setState(() {});
                              }
                            });
                          },
                        ),
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                          backgroundImage: Image.network(
                                  (value?[index].userParticipate?.display)
                                      .toString())
                              .image,
                          radius: 15,
                        ),
                        SizedBox(
                          width: screenw * 0.02,
                        ),
                        Text((value?[index].userParticipate?.name).toString(),
                            style: textStyle()),
                      ]));
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  TextStyle textStyle() {
    return TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), fontSize: 16);
  }
}

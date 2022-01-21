import 'package:curious_room/Models/CommentModel.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/Style/screenStyle.dart';
import 'package:curious_room/Views/Style/textStyle.dart';
import 'package:curious_room/Views/comment/commentHistory.dart';
import 'package:curious_room/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class CommentPage extends StatefulWidget {
  final int? postId;
  CommentPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  UserModel? usermodel;
  String content = "";
  TextEditingController contentController = TextEditingController();
  bool isTextFiledFocus = false;
  late Future<List<CommentModel>> future;
  late List<CommentModel>? value;

  @override
  void initState() {
    super.initState();
    future = getComment(widget.postId!);
  }

  @override
  Widget build(BuildContext context) {
    usermodel = context.watch<UserProvider>().userModel;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: screenh(context, 0.080),
          title: Text(
            "ยอดโหวต  0",
          ),
          titleTextStyle: normalTextStyle(20),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Color.fromRGBO(107, 103, 98, 1),
            iconSize: 50,
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Container(height: 75.h, child: getAllComment(context)),
            usermodel!.role == 'USER'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 1,
                        color: Color.fromRGBO(176, 162, 148, 1),
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 2.w,
                            ),
                            CircleAvatar(
                              backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                              backgroundImage: usermodel!.display.runtimeType
                                          .toString() ==
                                      "_File"
                                  ? Image.file(usermodel!.display).image
                                  : Image.network(usermodel!.display.toString())
                                      .image,
                              radius: 17,
                            ),
                            Expanded(
                              child: Focus(
                                  onFocusChange: (value) {
                                    setState(() {
                                      isTextFiledFocus = value;
                                    });
                                  },
                                  child: inputField(contentController)),
                            ),
                            IconButton(
                              color: Colors.black,
                              icon: Image(
                                  image: Image.asset('assets/icons/send.png')
                                      .image),
                              onPressed: () {
                                _buildButtonCreate();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        )));
  }

  Widget inputField(TextEditingController controller) {
    return TextFormField(
      onChanged: (value) => content = value.trim(),
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 19.sp),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        hintText: 'เพิ่มคำตอบของคุณ...',
        errorStyle: TextStyle(
          color: Colors.red[400],
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        contentPadding: EdgeInsets.all(15.0),
      ),
    );
  }

  getAllComment(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.data == []) {
            return Text(
              'ยังไม่มีคำตอบ',
              style: TextStyle(
                color: Color.fromRGBO(124, 124, 124, 1),
              ),
            );
          } else if (snapshot.hasData) {
            value = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: value!.length,
                itemBuilder: (context, index) {
                  //เปลี่ยนไทม์โซน
                  String time = DateFormat('Hm')
                      .format(value![index].createdAt.toLocal());
                  String date =
                      '${DateFormat.yMMMd().format(value![index].createdAt.toLocal())}';
                  return ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    title: Transform.scale(
                      scale: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Color.fromRGBO(255, 255, 255, 0),
                                  radius: 4.w,
                                  backgroundImage: Image.network(
                                          (value![index].userComment.display)
                                              .toString())
                                      .image,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white70),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    value![index].userComment.name,
                                    style: normalTextStyle(17.sp),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        date,
                                        style: normalTextStyle(15.sp),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        time,
                                        style: normalTextStyle(15.sp),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new CommentHistoryPage(
                                                        commentid:
                                                            value![index].id,
                                                      )));
                                        },
                                        child: Text(
                                          'ประวัติแก้ไข',
                                          style: normalTextStyle(15.sp),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        value![index]
                                            .commentHistory
                                            .first
                                            .content,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp),
                                      ),
                                      value![index].userComment.id ==
                                              usermodel!.id
                                          ? IconButton(
                                              color: Color.fromRGBO(
                                                  124, 124, 124, 1),
                                              icon: Icon(
                                                Icons.edit,
                                                size: 5.w,
                                              ),
                                              onPressed: () {},
                                            )
                                          : SizedBox()
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return Center(
              child: Column(children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 30,
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('กำลังโหลดข้อมูล...'),
            )
          ]));
        });
  }

  void _buildButtonCreate() async {}
}

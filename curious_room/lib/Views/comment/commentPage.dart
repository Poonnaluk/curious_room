import 'package:curious_room/Models/CommentModel.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/Style/screenStyle.dart';
import 'package:curious_room/Views/Style/textStyle.dart';
import 'package:curious_room/Views/comment/commentHistory.dart';
import 'package:curious_room/Views/utility/alertDialog.dart';
import 'package:curious_room/Views/utility/themeMoreButton.dart';
import 'package:curious_room/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class CommentPage extends StatefulWidget {
  final int? postId;
  final String score;
  final int ownerId;
  final int roomId;
  CommentPage(
      {Key? key,
      required this.postId,
      required this.score,
      required this.ownerId,
      required this.roomId})
      : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  UserModel? usermodel;
  String content = "";
  TextEditingController contentController = TextEditingController();
  TextEditingController editController = TextEditingController();
  bool isTextFiledFocus = false;
  late Future<List<CommentModel>> future;
  late List<CommentModel>? commentlist;
  bool _clickChanged = false;
  late int idxEdit = 9999;
  late int idxCheck = 9999;
  late int idxConfirm = 9999;
  late bool owner;

  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;

  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 1);
  }

  @override
  void initState() {
    super.initState();
    future = getComment(widget.postId!);
  }

  void deleteComment(int id) {
    setState(() {
      commentlist!.removeWhere((element) => element.id == id);
    });
  }

  Future<dynamic> refreashData() async {
    try {
      future = getComment(widget.postId!);
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    usermodel = context.watch<UserProvider>().userModel;
    FocusScopeNode currentFocus = FocusScope.of(context);
    owner = widget.ownerId == usermodel!.id ? true : false;
    return Scaffold(
        // backgroundColor: Colors,
        floatingActionButton: _buildSelectButton(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: screenh(context, 0.080),
          title: Text(
            "????????????????????? ${widget.score}",
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
            GestureDetector(
                onTap: () {
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                    isTextFiledFocus = false;
                  }
                },
                child: Container(
                    height: isTextFiledFocus ? 45.h : 75.h,
                    child: getAllComment(context))),
            usermodel!.role == 'USER' && _clickChanged == false
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
                                try {
                                  _buildButtonCreate(contentController);
                                } finally {
                                  currentFocus.unfocus();
                                  isTextFiledFocus = false;
                                }
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

  Widget _buildSelectButton() {
    // The button will be visible when the selectionMode is enabled.
    if (widget.ownerId == usermodel!.id) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 65.0, right: 5.0),
        child: Transform.scale(
            scale: 1.2,
            child: isSelectionMode
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      if (idxCheck != idxConfirm && idxEdit != 9999) {
                        print("idxCheck = $idxCheck");
                        print("idxConfirm = $idxConfirm");
                        bool success =
                            await confirmComment(widget.postId, idxEdit);
                        if (success) {
                          refreashData();
                          setState(() {
                            isSelectionMode = !isSelectionMode;
                          });
                        }
                      } else if (idxCheck == idxConfirm && idxEdit != 9999) {
                        bool success = await unConfirmComment(idxEdit);
                        if (success) {
                          refreashData();
                          setState(() {
                            isSelectionMode = !isSelectionMode;
                          });
                        }
                      } else {
                        setState(() {
                          isSelectionMode = !isSelectionMode;
                        });
                      }
                    },
                    label: const Text('??????????????????'),
                    backgroundColor: Colors.green,
                    icon: const Icon(
                      Icons.save_outlined,
                      color: Colors.white,
                    ),
                  )
                : FloatingActionButton.extended(
                    onPressed: () {
                      if (idxConfirm != 9999) {
                        selectedFlag[idxConfirm] = true;
                      }
                      setState(() {
                        isSelectionMode = !isSelectionMode;
                      });
                    },
                    label: const Text('??????????????????',
                        style: TextStyle(color: Colors.black)),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                  )),
      );
    } else {
      return SizedBox();
    }
  }

  Widget inputField(TextEditingController controller) {
    return TextFormField(
      onChanged: (value) => content = value.trim(),
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 19.sp),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        hintText: '????????????????????????????????????????????????...',
        errorStyle: TextStyle(
          color: Colors.red[400],
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        contentPadding: EdgeInsets.all(15.0),
      ),
    );
  }

  Widget buildDisplayNameField(int commentid, String content) {
    // final value = commentlist!.indexWhere(
    //     (element) => element.commentHistory.first.content == content);
    return Row(
      children: [
        Container(
          width: 55.w,
          height: 10.h,
          child: TextFormField(
            maxLines: 3,
            controller: editController,
            onChanged: (hasvalue) {
              setState(() {
                if (hasvalue != content && hasvalue != "") {
                  isTextFiledFocus = true;
                } else {
                  isTextFiledFocus = false;
                }
              });
            },
            style: TextStyle(color: Colors.black, fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
        ),
        IconButton(
          color: Color.fromRGBO(124, 124, 124, 1),
          icon: Icon(
            Icons.check,
            size: 5.w,
          ),
          onPressed: () async {
            if (isTextFiledFocus && editController.text != content) {
              bool success = await editComment(commentid, editController.text);
              if (success) {
                setState(() {
                  refreashData();
                  isTextFiledFocus = false;
                  _clickChanged = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Color.fromRGBO(119, 192, 182, 1),
                      content: Text(
                        '?????????????????????????????????',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Prompt',
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      )),
                );
              }
            } else {
              setState(() {
                isTextFiledFocus = false;
                _clickChanged = false;
              });
            }
          },
        )
      ],
    );
  }

  getAllComment(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.data == []) {
            return Text(
              '???????????????????????????????????????',
              style: TextStyle(
                color: Color.fromRGBO(124, 124, 124, 1),
              ),
            );
          } else if (snapshot.hasData) {
            commentlist = snapshot.data;
            List<int> data = [];

            return ListView.builder(
                // keyboardDismissBehavior:
                //     ScrollViewKeyboardDismissBehavior.onDrag,
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: commentlist!.length,
                itemBuilder: (context, index) {
                  for (int i = 0; i < commentlist!.length; i++) {
                    data.add(commentlist![index].id);
                  }
                  for (int j = 0; j < commentlist!.length; j++) {
                    if (commentlist![index].confirmStatus == true) {
                      idxConfirm = index;
                    }
                  }
                  //??????????????????????????????????????????
                  String time = DateFormat('Hm')
                      .format(commentlist![index].createdAt.toLocal());
                  String date =
                      '${DateFormat.yMMMd().format(commentlist![index].createdAt.toLocal())}';
                  selectedFlag[index] = selectedFlag[index] ?? false;
                  bool isSelected = selectedFlag[index]!;

                  return ListTile(
                    onTap: () {
                      onTap(isSelected, index, commentlist![index].id);
                    },
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    title: Transform.scale(
                      scale: 1,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(255, 255, 255, 0),
                                radius: 4.w,
                                backgroundImage: Image.network(
                                        (commentlist![index]
                                                .userComment
                                                .display)
                                            .toString())
                                    .image,
                              ),
                              isSelectionMode
                                  ? _buildSelectIcon(isSelected)
                                  : commentlist![index].confirmStatus == true
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, left: 10),
                                          child: Image.asset(
                                            'assets/icons/confirm_icon.png',
                                            scale: 1.1,
                                          ),
                                        )
                                      : SizedBox(
                                          height: 2.h,
                                        ),
                            ],
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    commentlist![index].userComment.name,
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
                                                            commentlist![index]
                                                                .id,
                                                      )));
                                        },
                                        child: Text(
                                          '????????????????????????????????????',
                                          style: normalTextStyle(15.sp),
                                        ),
                                      )
                                    ],
                                  ),
                                  _clickChanged && idxEdit == index
                                      ? buildDisplayNameField(
                                          commentlist![index].id,
                                          commentlist![index]
                                              .commentHistory
                                              .first
                                              .content)
                                      : Row(
                                          children: [
                                            Flexible(
                                              child: Container(
                                                child: Text(
                                                  commentlist![index]
                                                      .commentHistory
                                                      .first
                                                      .content,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.sp),
                                                  maxLines: 5,
                                                ),
                                              ),
                                            ),
                                            commentlist![index]
                                                            .userComment
                                                            .id ==
                                                        usermodel!.id ||
                                                    usermodel!.role == 'ADMIN'
                                                ? IconButton(
                                                    color: Color.fromRGBO(
                                                        124, 124, 124, 1),
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 5.w,
                                                    ),
                                                    onPressed: () {
                                                      moreButton(
                                                          context,
                                                          index,
                                                          commentlist![index]
                                                              .id,
                                                          commentlist![index]
                                                              .commentHistory
                                                              .first
                                                              .content);
                                                    },
                                                  )
                                                : SizedBox(),
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 30,
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('?????????????????????????????????????????????...'),
                )
              ]));
        });
  }

  Widget _buildSelectIcon(bool isSelected) {
    if (isSelectionMode) {
      return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Icon(
            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
            color: Theme.of(context).primaryColor,
          ));
    } else {
      return SizedBox();
    }
  }

  void onTap(bool isSelected, int index, int commentid) async {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        idxEdit = commentid;
        idxCheck = index;
        for (int i = 0; i <= commentlist!.length; i++) {
          if (i != index) {
            selectedFlag[i] = false;
          }
        }
      });
    }
  }

  void _buildButtonCreate(TextEditingController contentController) async {
    if (contentController.text != "") {
      await createComment(
          widget.postId!, usermodel!.id, contentController.text, widget.roomId);
      contentController.text = "";
      try {
        _scrollToBottom();
        await refreashData();
      } finally {
        _scrollToBottom();
        WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
      }
    }
  }

  moreButton(BuildContext context, int index, int commentid, String content) {
    bool isSuccess;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return Wrap(children: [
                usermodel!.role == 'USER'
                    ? TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          refreashData();
                          idxEdit = index;
                          _clickChanged = true;
                          editController.text = content;
                        },
                        child: themeMoreButton(
                            'assets/icons/edit_icon.png', '???????????????', 16))
                    : SizedBox(),
                Container(height: 1, color: Color.fromRGBO(107, 103, 98, 1.0)),
                TextButton(
                    onPressed: () async {
                      dynamic value = await confirmDialog(
                          context, '????????????????????????????????????????????????????????????????????????????????????????????????????????????');
                      if (value == 'true') {
                        final snackBar = SnackBar(
                          content: const Text('????????????????????????????????????????????????'),
                        );
                        isSuccess = await delComment(commentid);
                        if (isSuccess) {
                          Navigator.pop(context);
                          deleteComment(commentid);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: const Text('???????????????????????????????????????')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: themeMoreButton(
                        'assets/icons/delete_icon.png', '??????', 20))
              ]);
            });
      },
    );
  }
}

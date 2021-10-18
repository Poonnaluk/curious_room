import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreatePost extends StatefulWidget {
  CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = new GlobalKey<FormState>();

  late String name;
  TextEditingController nameController = TextEditingController();

  bool isTextFiledFocus = false;

  late double screenw;
  late double screenh;

  Widget inputField(TextEditingController controller) {
    return TextFormField(
      onChanged: (value) => name = value.trim(),
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 26),
      decoration: InputDecoration(
        hintText: 'กรุณากรอกชื่อห้องของคุณ',
        errorStyle: TextStyle(
          color: Colors.red[400],
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        contentPadding: EdgeInsets.all(15.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'คุณยังไม่ได้กรอกชื่อห้อง';
        }
        return null;
      },
    );
  }

  Widget _buildButtonCreate() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: !isTextFiledFocus
                ? Color.fromRGBO(237, 237, 237, 1)
                : Color.fromRGBO(69, 171, 157, 1),
            padding: const EdgeInsets.all(16.0),
            primary: Colors.white,
            textStyle: const TextStyle(fontSize: 22, fontFamily: 'Prompt'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Color.fromRGBO(119, 192, 182, 1),
                  content: Text(
                    'สร้างห้องสำเร็จ',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Prompt',
                        fontSize: 26),
                    textAlign: TextAlign.center,
                  )),
            );
            print(name);
          }
        },
        child: const Text('โพสต์'),
      ),
    );
  }

  getUsers() async {
    final response = await http.get(
        Uri.parse('http://192.168.43.94:8000/user/610107030011@dpu.ac.th'));
    print(response.body);
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: screenh * 0.08,
          title: new Text('สร้างคำถาม'),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 26, fontFamily: 'Prompt'),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
            color: Colors.black,
            iconSize: 50,
          ),
          actions: <Widget>[
            _buildButtonCreate(),
            SizedBox(
              width: screenw * 0.015,
            )
          ],
        ),
        body: const Center(
          child: Text('Create Post'),
        ),
      );
    }
  }
}

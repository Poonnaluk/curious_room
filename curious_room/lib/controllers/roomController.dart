import 'package:curious_room/Models/RoomModel.dart';

class RoomController {
  late RoomModel roomModel;
  late RoomModel aboutroom;

  addRoom(String name, int userid) async {
    roomModel = await createRoom(name, userid);
  }

  getAboutRoom(int id) async {
    aboutroom = await getRoom(id);
  }
}

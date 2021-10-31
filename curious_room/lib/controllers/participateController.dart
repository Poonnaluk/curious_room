import 'package:curious_room/Models/ParticipateModel.dart';

class ParticipateController {
  deleteParicipate(int roomid, int userid) async {
    await deleteParti(roomid, userid);
  }
}

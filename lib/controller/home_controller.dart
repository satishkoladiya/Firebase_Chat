import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:disease_tracker/api/apis.dart';

import '../models/chat_user.dart';

class HomeController extends GetxController {
  RxInt currentTab = 0.obs;
  RxString recentUserCount = "0".obs;
  RxList<ChatUser> userList = <ChatUser>[].obs;
  RxList<ChatUser> recentUserList = <ChatUser>[].obs;
  RxList<ChatUser> searchList = <ChatUser>[].obs;
  Rx<bool> isSearching = false.obs;
  Rx<String> userId = "0".obs;


  setUserList(
      {List<QueryDocumentSnapshot<Map<String, dynamic>>>? userListData}) {
    userList.value =
        userListData?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
  }

  getUserListById(List<String> userIdList) async {
    List<ChatUser> userDataList = [];
    for (var id in userIdList) {
      var user = await APIs.getUsers(id);
      var userData =
          user.docs.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
      userDataList.add(userData[0]);
    }
    recentUserList.value = userDataList;
  }
}

import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:disease_tracker/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../api/apis.dart';
import '../controller/home_controller.dart';
import '../main.dart';
import '../widgets/chat_user_card.dart';
import 'profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCount();
  }

  getCount() async {
    homeController.recentUserCount.value = await APIs.getMyUsersIdList();
    homeController.userId.value = APIs.user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0, bottom: 15, left: 15),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {},
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Get.to(ProfileScreen(user: APIs.me));
                      },
                      icon: const Icon(Icons.more_vert))
                ],
                centerTitle: true,
                title: const Text("Patients"),
              ),
              body: SingleChildScrollView(
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                  "Add, look up, update and run Al models for your patients, which makes easier to track appointments and treatment process",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  softWrap: true),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      "Dismiss",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blueAccent),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => TextField(
                          onTap: () {
                            homeController.isSearching.value = true;
                          },
                          onChanged: (val) {
                            homeController.searchList.clear();
                            for (var i in homeController.userList) {
                              if (i.name
                                      .toLowerCase()
                                      .contains(val.toLowerCase()) ||
                                  i.email
                                      .toLowerCase()
                                      .contains(val.toLowerCase())) {
                                homeController.searchList.add(i);
                              }
                            }
                          },
                          cursorColor: Colors.blueAccent,
                          cursorWidth: 3,
                          decoration: InputDecoration(
                            suffixIcon: homeController.isSearching.value
                                ? InkWell(
                                    onTap: () {
                                      homeController.isSearching.value = false;
                                      FocusScope.of(context).unfocus();
                                      homeController.searchList.clear();
                                    },
                                    child: const Icon(Icons.cancel_outlined,
                                        color: Colors.black54))
                                : const Icon(Icons.search,
                                    color: Colors.black54),
                            filled: true,
                            hintText: "Username, Name, Date...",
                            fillColor: Colors.blue.shade50,
                            floatingLabelStyle:
                                const TextStyle(color: Colors.blueAccent),
                            hintMaxLines: 1,
                            hintTextDirection: TextDirection.ltr,
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              "Use username or email to start a new chat",
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Obx(
                        () => homeController.isSearching.value
                            ? const SizedBox.shrink()
                            : ButtonsTabBar(
                                height: 38,
                                onTap: (tabIndex) {
                                  log("$tabIndex");
                                  homeController.currentTab.value = tabIndex;
                                },
                                // decoration: BoxDecoration(),
                                unselectedDecoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                ),
                                splashColor: Colors.transparent,
                                radius: 100,
                                // backgroundColor: AppColors.completed_color,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 17,
                                ),
                                unselectedLabelStyle:
                                    const TextStyle(color: Colors.black),
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                //duration: 500,
                                tabs: [
                                  ["Chats", Icons.chat_outlined],
                                  ["New patients", Icons.person_add_alt],
                                  ["Unread", Icons.mark_chat_unread_outlined],
                                  ["Archive", Icons.archive_outlined],
                                ]
                                    .mapIndexed(
                                      (index, List label) => Tab(
                                        // text: label,
                                        child: Row(
                                          children: [
                                            Obx(
                                              () => homeController
                                                          .currentTab.value ==
                                                      index
                                                  ? Icon(
                                                      label[1],
                                                      color: Colors.white,
                                                      size: 15,
                                                    )
                                                  : Icon(
                                                      label[1],
                                                      color: Colors.black,
                                                      size: 15,
                                                    ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Obx(
                                              () => homeController
                                                          .currentTab.value ==
                                                      index
                                                  ? Text(
                                                      label[0].toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  : Text(
                                                      label[0].toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                      Obx(
                        () => homeController.isSearching.value
                            ? const SizedBox.shrink()
                            : homeController.recentUserCount.value == "0"
                                ? const SizedBox.shrink()
                                : const Padding(
                                    padding:
                                        EdgeInsets.only(top: 13.0, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Recent",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                      ),
                      Obx(
                        () => homeController.isSearching.value
                            ? const SizedBox.shrink()
                            : homeController.recentUserCount.value == "0"
                                ? const SizedBox.shrink()
                                : SizedBox(
                                    height: (mq.height * 0.095) * int.parse(homeController.recentUserCount.value),
                                    child: TabBarView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        StreamBuilder(
                                          stream: APIs.getMyUsersId(),
                                          //get id of only known users
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              //if data is loading
                                              case ConnectionState.waiting:
                                              case ConnectionState.none:
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());

                                              //if some or all data is loaded then show it
                                              case ConnectionState.active:
                                              case ConnectionState.done:
                                                return FutureBuilder(
                                                  future: homeController
                                                      .getUserListById(snapshot
                                                              .data?.docs
                                                              .map((e) => e.id)
                                                              .toList() ??
                                                          []),
                                                  //get only those user, who's ids are provided
                                                  builder: (context, snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      //if data is loading
                                                      case ConnectionState
                                                            .waiting:
                                                      case ConnectionState.none:
                                                      // return const Center(
                                                      //     child: CircularProgressIndicator());
                                                      //if some or all data is loaded then show it
                                                      case ConnectionState
                                                            .active:
                                                      case ConnectionState.done:
                                                        if (homeController
                                                            .recentUserList
                                                            .isNotEmpty) {
                                                          return ListView
                                                              .builder(
                                                                  itemCount:
                                                                      homeController
                                                                          .recentUserList
                                                                          .length,
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return ChatUserCard(
                                                                      user: homeController
                                                                              .recentUserList[
                                                                          index],
                                                                      onChatTap:
                                                                          () {
                                                                        Get.to(ChatScreen(user: homeController.recentUserList[index]))
                                                                            ?.then((value) {
                                                                          if (value ==
                                                                              true) {
                                                                            getCount();
                                                                          }
                                                                        });
                                                                      },
                                                                    );
                                                                  });
                                                        } else {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                    }
                                                  },
                                                );
                                            }
                                          },
                                        ),
                                        StreamBuilder(
                                          stream: APIs.getMyUsersId(),
                                          //get id of only known users
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              //if data is loading
                                              case ConnectionState.waiting:
                                              case ConnectionState.none:
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());

                                              //if some or all data is loaded then show it
                                              case ConnectionState.active:
                                              case ConnectionState.done:
                                                return FutureBuilder(
                                                  future: homeController
                                                      .getUserListById(snapshot
                                                              .data?.docs
                                                              .map((e) => e.id)
                                                              .toList() ??
                                                          []),
                                                  //get only those user, who's ids are provided
                                                  builder: (context, snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      //if data is loading
                                                      case ConnectionState
                                                            .waiting:
                                                      case ConnectionState.none:
                                                      // return const Center(
                                                      //     child: CircularProgressIndicator());
                                                      //if some or all data is loaded then show it
                                                      case ConnectionState
                                                            .active:
                                                      case ConnectionState.done:
                                                        if (homeController
                                                            .recentUserList
                                                            .isNotEmpty) {
                                                          return ListView
                                                              .builder(
                                                                  itemCount:
                                                                      homeController
                                                                          .recentUserList
                                                                          .length,
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return ChatUserCard(
                                                                      user: homeController
                                                                              .recentUserList[
                                                                          index],
                                                                      onChatTap:
                                                                          () {
                                                                        Get.to(ChatScreen(user: homeController.recentUserList[index]))
                                                                            ?.then((value) {
                                                                          if (value ==
                                                                              true) {
                                                                            getCount();
                                                                          }
                                                                        });
                                                                      },
                                                                    );
                                                                  });
                                                        } else {
                                                          return const Center(
                                                            child: Text(
                                                                'No Connections Found!',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                          );
                                                        }
                                                    }
                                                  },
                                                );
                                            }
                                          },
                                        ),
                                        StreamBuilder(
                                          stream: APIs.getMyUsersId(),
                                          //get id of only known users
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              //if data is loading
                                              case ConnectionState.waiting:
                                              case ConnectionState.none:
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());

                                              //if some or all data is loaded then show it
                                              case ConnectionState.active:
                                              case ConnectionState.done:
                                                return FutureBuilder(
                                                  future: homeController
                                                      .getUserListById(snapshot
                                                              .data?.docs
                                                              .map((e) => e.id)
                                                              .toList() ??
                                                          []),
                                                  //get only those user, who's ids are provided
                                                  builder: (context, snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      //if data is loading
                                                      case ConnectionState
                                                            .waiting:
                                                      case ConnectionState.none:
                                                      // return const Center(
                                                      //     child: CircularProgressIndicator());
                                                      //if some or all data is loaded then show it
                                                      case ConnectionState
                                                            .active:
                                                      case ConnectionState.done:
                                                        if (homeController
                                                            .recentUserList
                                                            .isNotEmpty) {
                                                          return ListView
                                                              .builder(
                                                                  itemCount:
                                                                      homeController
                                                                          .recentUserList
                                                                          .length,
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return ChatUserCard(
                                                                      user: homeController
                                                                              .recentUserList[
                                                                          index],
                                                                      onChatTap:
                                                                          () {
                                                                        Get.to(ChatScreen(user: homeController.recentUserList[index]))
                                                                            ?.then((value) {
                                                                          if (value ==
                                                                              true) {
                                                                            getCount();
                                                                          }
                                                                        });
                                                                      },
                                                                    );
                                                                  });
                                                        } else {
                                                          return const Center(
                                                            child: Text(
                                                                'No Connections Found!',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                          );
                                                        }
                                                    }
                                                  },
                                                );
                                            }
                                          },
                                        ),
                                        StreamBuilder(
                                          stream: APIs.getMyUsersId(),
                                          //get id of only known users
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              //if data is loading
                                              case ConnectionState.waiting:
                                              case ConnectionState.none:
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());

                                              //if some or all data is loaded then show it
                                              case ConnectionState.active:
                                              case ConnectionState.done:
                                                return FutureBuilder(
                                                  future: homeController
                                                      .getUserListById(snapshot
                                                              .data?.docs
                                                              .map((e) => e.id)
                                                              .toList() ??
                                                          []),
                                                  //get only those user, who's ids are provided
                                                  builder: (context, snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      //if data is loading
                                                      case ConnectionState
                                                            .waiting:
                                                      case ConnectionState.none:
                                                      // return const Center(
                                                      //     child: CircularProgressIndicator());
                                                      //if some or all data is loaded then show it
                                                      case ConnectionState
                                                            .active:
                                                      case ConnectionState.done:
                                                        if (homeController
                                                            .recentUserList
                                                            .isNotEmpty) {
                                                          return ListView
                                                              .builder(
                                                                  itemCount:
                                                                      homeController
                                                                          .recentUserList
                                                                          .length,
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return ChatUserCard(
                                                                      user: homeController
                                                                              .recentUserList[
                                                                          index],
                                                                      onChatTap:
                                                                          () {
                                                                        Get.to(ChatScreen(user: homeController.recentUserList[index]))
                                                                            ?.then((value) {
                                                                          if (value ==
                                                                              true) {
                                                                            getCount();
                                                                          }
                                                                        });
                                                                      },
                                                                    );
                                                                  });
                                                        } else {
                                                          return const Center(
                                                            child: Text(
                                                                'No Connections Found!',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                          );
                                                        }
                                                    }
                                                  },
                                                );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 13.0, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "All patients",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Recent first -',
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  " tap to filter",
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 11),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: APIs.getAllUsersList(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              homeController.setUserList(userListData: data);
                              if (homeController.userList.isNotEmpty) {
                                return Obx(
                                  () => ListView.builder(
                                      itemCount:
                                          homeController.isSearching.value
                                              ? homeController.searchList.length
                                              : homeController.userList.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Obx(() => homeController
                                                    .userList[index].id !=
                                                homeController.userId.value
                                            ? ChatUserCard(
                                                user: homeController
                                                        .isSearching.value
                                                    ? homeController
                                                        .searchList[index]
                                                    : homeController
                                                        .userList[index],
                                                onChatTap: () {
                                                  Get.to(ChatScreen(
                                                          user: homeController
                                                              .userList[index]))
                                                      ?.then((value) {
                                                    if (value == true) {
                                                      getCount();
                                                    }
                                                  });
                                                },
                                              )
                                            : const SizedBox.shrink());
                                      }),
                                );
                              } else {
                                return const Center(
                                  child: Text('No Connections Found!',
                                      style: TextStyle(fontSize: 20)),
                                );
                              }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:recipient/firebase_request.dart';
import 'package:recipient/recipe_layout/my_recipe_layout.dart';
import 'package:recipient/util.dart';

import 'Provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, required this.uploaderId})
      : super(key: key);

  final String uploaderId;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  String userUid = "";

  @override
  void initState() {

    userUid = FirebaseAuth.instance.currentUser?.uid ?? "";

    Provider.of<MainProvider>(context, listen: false)
        .fetchProfile(widget.uploaderId);
    Provider.of<MainProvider>(context, listen: false)
        .fetchUserRecipes(widget.uploaderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.asset(
                        "asset/image/profile_bg.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: const Color.fromRGBO(230, 230, 230, 0.5),
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 200,
                  left: 5,
                  right: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Container(
                            height: 180,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${Provider.of<MainProvider>(context).registerModel.firstName} ${Provider.of<MainProvider>(context).registerModel.lastName}",
                                  style: const TextStyle(
                                      fontFamily: mainFont, fontSize: 18),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("User Information")
                                            .doc(widget.uploaderId)
                                            .collection("Followers")
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              "${snapshot.data?.docs.length} Pengikut",
                                              style: const TextStyle(
                                                  fontFamily: mainFont,
                                                  color: Colors.black54),
                                            );
                                          } else {
                                            return const Text(
                                              "0 Pengikut",
                                              style: TextStyle(
                                                  fontFamily: mainFont,
                                                  color: Colors.black54),
                                            );
                                          }
                                        }),
                                    const Text(
                                      ".",
                                      style: TextStyle(
                                          fontFamily: mainFont, fontSize: 20),
                                    ),
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("User Information")
                                          .doc(widget.uploaderId)
                                          .collection("Followings")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data?.docs.length} Diikuti",
                                            style: const TextStyle(
                                                fontFamily: mainFont,
                                                color: Colors.black54),
                                          );
                                        } else {
                                          return const Text(
                                            "0 Diikuti",
                                            style: TextStyle(
                                                fontFamily: mainFont,
                                                color: Colors.black54),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("User Information")
                                        .doc(userUid)
                                        .collection("Followings")
                                        .doc(widget.uploaderId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                        if (snapshot.data?.exists == true) {
                                          return const SizedBox();
                                        } else {
                                          return ElevatedButton.icon(
                                            onPressed: () async {
                                              await following(widget.uploaderId, userUid);
                                            },
                                            icon: const Icon(Icons.add),
                                            label: const Text(
                                              "Ikuti",
                                              style: TextStyle(
                                                fontFamily: mainFont,
                                              ),
                                            ),
                                          );
                                        }
                                    })
                              ],
                            ),
                          )),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 24.0),
                        child: Text(
                          "Resep Anda",
                          style: TextStyle(
                            fontFamily: mainFont,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      StaggeredGrid.count(
                        crossAxisCount: 2,
                        children: Provider.of<MainProvider>(context)
                            .userRecipes
                            .map((e) {
                          return MyRecipeLayout(
                            recipe: e,
                            profileUrl: Provider.of<MainProvider>(context).registerModel.photoUrl,
                            mode: 'user',
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 140,
                  left: 1,
                  right: 1,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: CachedNetworkImage(
                        height: 120,
                        width: 120,
                        imageUrl: Provider.of<MainProvider>(context)
                            .registerModel
                            .photoUrl,
                        placeholder: (context, _) => const Icon(
                          Icons.account_circle_rounded,
                          color: Colors.black54,
                          size: 120,
                        ),
                        errorWidget: (context, _, __) => const Icon(
                          Icons.account_circle_rounded,
                          size: 120,
                          color: Colors.black54,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 1,
                  left: 1,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SafeArea(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.keyboard_arrow_left),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

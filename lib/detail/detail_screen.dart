import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:recipient/model/RecipeModel.dart';
import 'package:recipient/firebase_request.dart';
import 'package:recipient/model/register_model.dart';
import 'package:recipient/user_profile_screen.dart';
import 'package:recipient/util.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.recipe}) : super(key: key);

  final RecipeModel recipe;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentTabIndex = 0;

  String userUid = "";

  @override
  void initState() {
    userUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 250,
                      child: CachedNetworkImage(
                        imageUrl: widget.recipe.photoUrl,
                        placeholder: (context, _) => const Image(
                          image: AssetImage("asset/image/placeholder_food.jpg"),
                          fit: BoxFit.fill,
                        ),
                        errorWidget: (context, _, __) => const Image(
                          image: AssetImage("asset/image/placeholder_food.jpg"),
                          fit: BoxFit.fill,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 180,
                      color: const Color.fromRGBO(230, 230, 230, 0.5),
                    ),
                  ],
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
                Positioned(
                  bottom: 15,
                  left: 5,
                  right: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.recipe.title,
                              style: const TextStyle(
                                  fontFamily: mainFont,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfileScreen(
                                          uploaderId: widget.recipe.uploaderId),
                                    ),
                                  );
                                },
                                child: FutureBuilder<RegisterModel>(
                                    future:
                                        getProfile(widget.recipe.uploaderId),
                                    builder: (context, snapshot) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.white,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              child: CachedNetworkImage(
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    snapshot.data?.photoUrl ??
                                                        "",
                                                placeholder: (context, url) =>
                                                    const Icon(
                                                  Icons.account_circle_rounded,
                                                  size: 50,
                                                  color: Colors.black38,
                                                ),
                                                errorWidget: (context, _, __) =>
                                                    const Icon(
                                                  Icons.account_circle_rounded,
                                                  size: 50,
                                                  color: Colors.black38,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${snapshot.data?.firstName ?? ""}  ${snapshot.data?.lastName ?? ""}",
                                              style: const TextStyle(
                                                  fontFamily: mainFont,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Recipe")
                                        .doc(widget.recipe.recipeId.toString())
                                        .collection("Rating")
                                        .doc(userUid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return RatingBar(
                                        itemSize: 20,
                                        ignoreGestures:
                                            snapshot.data?.exists == true,
                                        initialRating: snapshot.data?.exists ==
                                                true
                                            ? snapshot.data?.data()!['rating']
                                            : 0,
                                        ratingWidget: RatingWidget(
                                          full: const Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                          half: const Icon(
                                            Icons.star_half,
                                            color: Colors.yellow,
                                          ),
                                          empty: const Icon(
                                            Icons.star,
                                            color: Colors.black26,
                                          ),
                                        ),
                                        onRatingUpdate: (value) async {
                                          if (snapshot.data?.exists == false) {
                                            await addRating(
                                                value,
                                                userUid,
                                                widget.recipe.recipeId
                                                    .toString());
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Recipe")
                                        .doc(widget.recipe.recipeId.toString())
                                        .collection("Rating")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "(${snapshot.data?.docs.length} Reviews)",
                                          style: const TextStyle(
                                              fontFamily: mainFont,
                                              color: Colors.black54),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Divider(
                                height: 1.8,
                                thickness: 1,
                                indent: 1,
                                endIndent: 1,
                                color: Colors.black12,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.access_time_outlined,
                                        color: mainColor,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "${widget.recipe.duration} menit",
                                          style: const TextStyle(
                                              fontFamily: mainFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                    child: VerticalDivider(
                                      width: 1.8,
                                      thickness: 1,
                                      indent: 1,
                                      endIndent: 1,
                                      color: Colors.black12,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.restaurant,
                                        color: mainColor,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "${widget.recipe.portion} porsi",
                                          style: const TextStyle(
                                              fontFamily: mainFont),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentTabIndex = 0;
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color:
                              currentTabIndex == 0 ? mainColor : Colors.white,
                          borderRadius: BorderRadius.circular(18.0)),
                      child: Text(
                        "Deskripsi",
                        style: TextStyle(
                            fontFamily: mainFont,
                            color: currentTabIndex == 0
                                ? Colors.white
                                : Colors.black54,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentTabIndex = 1;
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color:
                              currentTabIndex == 1 ? mainColor : Colors.white,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Text(
                        "Bahan",
                        style: TextStyle(
                            fontFamily: mainFont,
                            color: currentTabIndex == 1
                                ? Colors.white
                                : Colors.black54,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentTabIndex = 2;
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color:
                              currentTabIndex == 2 ? mainColor : Colors.white,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Text(
                        "Langkah",
                        style: TextStyle(
                            fontFamily: mainFont,
                            color: currentTabIndex == 2
                                ? Colors.white
                                : Colors.black54,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            currentTabIndex == 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.recipe.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontFamily: mainFont),
                    ),
                  )
                : currentTabIndex == 1
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HtmlWidget(
                          widget.recipe.material,
                          textStyle: const TextStyle(
                              fontFamily: mainFont, color: Colors.black),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HtmlWidget(
                          widget.recipe.step,
                          textStyle: const TextStyle(
                              fontFamily: mainFont, color: Colors.black),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}

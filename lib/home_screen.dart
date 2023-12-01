import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:recipient/Provider.dart';
import 'package:recipient/recipe_layout/recipe_layout.dart';
import 'package:recipient/search_screen.dart';
import 'package:recipient/util.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userUid = "";

  @override
  void initState() {
    userUid = FirebaseAuth.instance.currentUser?.uid ?? "";

    Provider.of<MainProvider>(context, listen: false).fetchProfile(userUid);
    Provider.of<MainProvider>(context, listen: false).fetchRecipes(userUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 32.0),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl: Provider.of<MainProvider>(context)
                              .registerModel
                              .photoUrl,
                          placeholder: (context, url) => const Icon(
                            Icons.account_circle_rounded,
                            size: 50,
                            color: Colors.black38,
                          ),
                          errorWidget: (context, _, __) => const Icon(
                            Icons.account_circle_rounded,
                            size: 50,
                            color: Colors.black38,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hai ${Provider.of<MainProvider>(context).registerModel.firstName}",
                          style: const TextStyle(
                              fontFamily: mainFont,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        const Text(
                          "Mau masak apa hari ini ?",
                          style: TextStyle(
                              fontFamily: mainFont, color: Colors.black38),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(profileUrl: Provider.of<MainProvider>(context).registerModel.photoUrl,),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  margin:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.black12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Cari Nama Resep",
                        style: TextStyle(
                          fontFamily: mainFont,
                          color: Colors.black54,
                        ),
                      ),
                      Image(
                        image: AssetImage("asset/image/search_n.png"),
                        width: 24,
                        height: 24,
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                  top: 32.0,
                  bottom: 8.0,
                ),
                child: Text(
                  "Terbaru",
                  style: TextStyle(
                    fontFamily: mainFont,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              StaggeredGrid.count(
                crossAxisCount: 2,
                children: Provider.of<MainProvider>(context).recipes.map((e)  {
                  return RecipeLayout(
                    recipe: e,
                    userUid: userUid
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ignore: unused_element
  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}

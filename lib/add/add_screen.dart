import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recipient/model/RecipeModel.dart';
import 'package:recipient/add/add_recipe_screen.dart';
import 'package:recipient/add/update_recipe_screen.dart';
import 'package:recipient/util.dart';
import 'package:recipient/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../recipe_layout/favorite_recipe_layout.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  // TODO: Add _bannerAd
  // ignore: unused_field
  BannerAd? _bannerAd;

  String userUid = "";

  @override
  void initState() {
    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    userUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 24.0),
              child: Text(
                "Draft Resep",
                style: TextStyle(
                  fontFamily: mainFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),

            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 24),
              child: Row(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Recipe")
                        .where('status', isEqualTo: 'not publish')
                        .where('uploaderId', isEqualTo: userUid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.toList().length ?? 0,
                            itemBuilder: (context, index) {
                              RecipeModel recipe = RecipeModel.fromMap(
                                  snapshot.data!.docs.toList()[index].data());
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateRecipeScreen(
                                        recipeModel: recipe,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 121,
                                        height: 90,
                                        child: CachedNetworkImage(
                                          imageUrl: recipe.photoUrl,
                                          placeholder: (context, _) =>
                                              const Image(
                                            image: AssetImage(
                                                "asset/image/back_img2.png"),
                                          ),
                                          errorWidget: (context, _, __) =>
                                              const Image(
                                            image: AssetImage(
                                                "asset/image/back_img2.png"),
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          recipe.title.isEmpty
                                              ? "Belum ada judul"
                                              : recipe.title,
                                          style: const TextStyle(
                                            fontFamily: mainFont,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddRecipeScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.add_circle_outline,
                            size: 40,
                          ),
                          Text(
                            "Tambah",
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: mainFont,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "Resep Baru",
                            style: TextStyle(
                              fontFamily: mainFont,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                top: 38.0,
              ),
              child: Text(
                "Resep Tersimpan",
                style: TextStyle(
                  fontFamily: mainFont,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Information")
                  .doc(userUid)
                  .collection("Favorite")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: StaggeredGrid.count(
                          crossAxisCount: 2,
                          children: snapshot.data!.docs.map((e)  {
                            return FavoriteRecipeLayout(
                              recipe: RecipeModel.fromMap(e.data()),
                              userUid: userUid,
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              'asset/image/empty_img.png',
                              height: 100,
                              width: 100,
                            ),
                            const Text(
                              "Belum ada resep tersimpan",
                              style:
                                  TextStyle(fontFamily: mainFont, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();
    super.dispose();
  }
}

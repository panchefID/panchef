import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:recipient/Provider.dart';
import 'package:recipient/recipe_layout/recipe_layout.dart';
import 'package:recipient/util.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.profileUrl}) : super(key: key);

  final String profileUrl;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String userUid = "";
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    userUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    searchFocus.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(fontFamily: mainFont),
                    cursorColor: mainColor,
                    focusNode: searchFocus,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      hintText: "Cari nama resep",
                      hintStyle: const TextStyle(fontFamily: mainFont),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset("asset/image/search_n.png"),
                      ),
                      suffixIconConstraints:
                          const BoxConstraints(maxWidth: 32, maxHeight: 32),
                      contentPadding: const EdgeInsets.only(left: 8),
                    ),
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Provider.of<MainProvider>(context, listen: false)
                            .searchRecipe(value, userUid);
                      }
                    },
                  ),
                ),
              ],
            ),
            Provider.of<MainProvider>(context).searchRecipes.isNotEmpty
                ? Expanded(
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      children:
                          Provider.of<MainProvider>(context).searchRecipes.map((e) {
                        return RecipeLayout(
                          recipe: e,
                          userUid: userUid,
                        );
                      }).toList(),
                    ),
                  )
                : Provider.of<MainProvider>(context).isLoading
                    ? Expanded(
                        child: Center(
                          child: Lottie.asset(
                            "asset/animation/data.json",
                            width: 50,
                            height: 50,
                          ),
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: Text(
                            "Resep tidak ditemukan",
                            style: TextStyle(
                                fontFamily: mainFont,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                                fontSize: 16),
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}

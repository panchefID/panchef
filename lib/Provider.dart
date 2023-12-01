import 'package:flutter/foundation.dart';
import 'package:recipient/model/register_model.dart';

import 'model/RecipeModel.dart';
import 'firebase_request.dart';

class MainProvider extends ChangeNotifier {
  RegisterModel registerModel = RegisterModel();

  void fetchProfile(String userUid) {
    getProfile(userUid).then((value) {
      registerModel = value;
      notifyListeners();
    });
  }

  List<RecipeModel> recipes = [];

  void fetchRecipes(String userUid) {
    recipes.clear();
    getAllRecipes(userUid).then((value) {
      recipes.addAll(value);
      notifyListeners();
    });
  }

  List<RecipeModel> userRecipes = [];
  void fetchUserRecipes(String userUid) {
    userRecipes.clear();
    getUserRecipes(userUid).then((value) {
      userRecipes.addAll(value);
      notifyListeners();
    });
  }

  List<RecipeModel> searchRecipes = [];
  bool isLoading = false;

  void searchRecipe(String title, String userUid) {
    searchRecipes = [];
    isLoading = true;
    notifyListeners();
    getAllRecipes(userUid).then((value) {
      for (var recipe in value) {
        if (recipe.title.toUpperCase().contains(title.toUpperCase())) {
          searchRecipes.add(recipe);
        }
      }
      isLoading = false;
      notifyListeners();
    });
  }

}

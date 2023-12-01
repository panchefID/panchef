import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipient/model/RecipeModel.dart';
import 'package:recipient/model/register_model.dart';
import 'package:recipient/model/upload_result.dart';

Future<void> addRecipe(RecipeModel model) async {
  return await FirebaseFirestore.instance
      .collection("Recipe")
      .doc(model.recipeId.toString())
      .set(model.toMap());
}

Future<void> updateRecipe(RecipeModel model) async {
  return await FirebaseFirestore.instance
      .collection("Recipe")
      .doc(model.recipeId.toString())
      .update(model.toMap());
}

Future<void> deleteRecipe(RecipeModel model) async {
  return await FirebaseFirestore.instance
      .collection("Recipe")
      .doc(model.recipeId.toString())
      .delete();
}


Future<UploadResult> uploadImage(File file, String recipeId) async {
  try {
    final snap = await FirebaseStorage.instance
        .ref()
        .child("Recipe Resources").child(recipeId)
        .putFile(file);
    var url = await snap.ref.getDownloadURL();
    return UploadResult(url, null);
  } on FirebaseException catch (e) {
    return UploadResult(null, e.message);
  }
}

Future<RegisterModel> getProfile(String userUid) async {
  final snapshot = await FirebaseFirestore.instance
      .collection("User Information")
      .doc(userUid)
      .get();
  if (snapshot.exists) {
    return RegisterModel.fromMap(snapshot.data()!);
  } else {
    return RegisterModel();
  }
}

Future<List<RecipeModel>> getAllRecipes(String userUid) async {
  List<RecipeModel> recipes = [];
  final snapshot = await FirebaseFirestore.instance.collection("Recipe").where('uploaderId', isNotEqualTo: userUid).where('status', isEqualTo: 'publish').get();
  if (snapshot.docs.isNotEmpty) {
    for (var element in snapshot.docs) {
      recipes.add(RecipeModel.fromMap(element.data()));
    }
  }
  return recipes;
}

Future<List<RecipeModel>> getUserRecipes(String userUid) async {
  List<RecipeModel> recipes = [];
  final snapshot = await FirebaseFirestore.instance.collection("Recipe").where('status', isEqualTo: 'publish').where('uploaderId', isEqualTo: userUid).get();
  if (snapshot.docs.isNotEmpty) {
    for (var element in snapshot.docs) {
      recipes.add(RecipeModel.fromMap(element.data()));
    }
  }
  return recipes;
}

Future<void> addFavorite(RecipeModel recipeModel, String userUid) async {
  return await FirebaseFirestore.instance
      .collection("User Information")
      .doc(userUid)
      .collection("Favorite")
      .doc(recipeModel.recipeId.toString())
      .set(recipeModel.toMap());
}

Future<void> deleteFavorite(RecipeModel recipeModel, String userUid) async {
  return await FirebaseFirestore.instance
      .collection("User Information")
      .doc(userUid)
      .collection("Favorite")
      .doc(recipeModel.recipeId.toString())
      .delete();
}

Future<void> following(String uploaderId, String userUid) async {
  await FirebaseFirestore.instance.collection("User Information").doc(userUid).collection("Followings").doc(uploaderId).set({'userUid':uploaderId});
  await FirebaseFirestore.instance.collection("User Information").doc(uploaderId).collection("Followers").doc(userUid).set({'userUid':userUid});
}

Future<UploadResult> uploadProfileImage(File file, String userUid) async {
  try {
    final snap = await FirebaseStorage.instance
        .ref()
        .child("Profile Resources").child(userUid)
        .putFile(file);
    var url = await snap.ref.getDownloadURL();
    return UploadResult(url, null);
  } on FirebaseException catch (e) {
    return UploadResult(null, e.message);
  }
}

Future<void> updateProfile(String url, String userUid) async {
  await FirebaseFirestore.instance.collection("User Information").doc(userUid).update({'photoUrl':url});
}

Future<void> addRating(double rating, String userUid, String recipeId) async {
  await FirebaseFirestore.instance.collection("Recipe").doc(recipeId).collection("Rating").doc(userUid).set({'rating':rating});
}

Future<Map<dynamic, dynamic>> averageRating(String recipeId) async {
  final snapshot = await FirebaseFirestore.instance.collection("Recipe").doc(recipeId).collection("Rating").get();
  var map = {};

  for (var element in snapshot.docs) {
    if (!map.containsKey(element.data()['rating'])){
      map[element.data()['rating']] = 1;
    } else {
      map[element.data()['rating']] += 1;
    }
  }
  return map;
}

Future<void> deleteUserRecipe(String recipeId) async {
  final instance = FirebaseFirestore.instance;
  final batch = instance.batch();
  var collection = instance.collection('Recipe').doc(recipeId).collection('Rating');
  var snapshots = await collection.get();
  for (var doc in snapshots.docs) {
    batch.delete(doc.reference);
  }
  await batch.commit();
  await instance.collection('Recipe').doc(recipeId).delete();
}

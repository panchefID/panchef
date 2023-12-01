class RecipeModel {
  int recipeId = 0;
  String photoUrl = "";
  String title = "";
  String description = "";
  int duration = 0;
  int portion = 0;
  String material = "";
  String step = "";
  String uploaderId = "";
  String status = "";

  RecipeModel({
    required this.recipeId,
    required this.photoUrl,
    required this.title,
    required this.description,
    required this.duration,
    required this.portion,
    required this.material,
    required this.step,
    required this.uploaderId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'photoUrl': photoUrl,
      'title': title,
      'description': description,
      'duration': duration,
      'portion': portion,
      'material': material,
      'step': step,
      'uploaderId': uploaderId,
      'status': status
    };
  }

  RecipeModel.fromMap(Map<String, dynamic> recipeMap)
      : recipeId = recipeMap['recipeId'],
        photoUrl = recipeMap['photoUrl'],
        title = recipeMap['title'],
        description = recipeMap['description'],
        duration = recipeMap['duration'],
        portion = recipeMap['portion'],
        material = recipeMap['material'],
        step = recipeMap['step'],
        uploaderId = recipeMap['uploaderId'],
        status = recipeMap['status'];
}

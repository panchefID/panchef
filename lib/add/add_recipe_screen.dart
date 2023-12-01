import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:recipient/model/RecipeModel.dart';
import 'package:recipient/editor_screen.dart';
import 'package:recipient/firebase_request.dart';

import 'package:recipient/util.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cDurationController = TextEditingController();
  TextEditingController portionController = TextEditingController();
  TextEditingController materialsController = TextEditingController();
  TextEditingController stepController = TextEditingController();

  var stepHtml = '<p>Masukkan Langkah - langkah</p>';
  var materialHtml = '<p>Masukkan Bahan - bahan</p>';

  var currentStepHtml = '';
  var currentMaterialHtml = '';

  image_picker.XFile? imageFile = image_picker.XFile('');

  String userUid = "";

  @override
  void initState() {
    userUid = FirebaseAuth.instance.currentUser?.uid ?? "";
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
              Stack(
                children: [
                  InkWell(
                    onTap: () async {
                      final image_picker.ImagePicker picker = image_picker.ImagePicker();
                      final image_picker.XFile? file =
                          await picker.pickImage(source: image_picker.ImageSource.gallery);

                      setState(() {
                        imageFile = file;
                      });
                    },
                    child: imageFile == null || imageFile?.path.isEmpty == true
                        ? Container(
                            padding: const EdgeInsets.all(8.0),
                            width: double.infinity,
                            height: 250,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("asset/image/back_img2.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: DottedBorder(
                                color: Colors.white,
                                strokeWidth: 2,
                                dashPattern: const [10, 3],
                                radius: const Radius.circular(20.0),
                                borderType: BorderType.RRect,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        color: Colors.white,
                                        size: 70,
                                      ),
                                      Text(
                                        "Tambahkan Foto Cover",
                                        style: TextStyle(
                                            fontFamily: mainFont,
                                            fontSize: 18,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(8.0),
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(imageFile!.path)),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: DottedBorder(
                                color: Colors.white,
                                strokeWidth: 2,
                                dashPattern: const [10, 3],
                                radius: const Radius.circular(20.0),
                                borderType: BorderType.RRect,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        color: Colors.white,
                                        size: 70,
                                      ),
                                      Text(
                                        "Tambahkan Foto Cover",
                                        style: TextStyle(
                                            fontFamily: mainFont,
                                            fontSize: 18,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        shape: const CircleBorder(),
                        child: IconButton(
                          onPressed: () {
                            showDialogs(context);
                            var recipeId =
                                DateTime.now().microsecondsSinceEpoch;
                            var title = titleController.text;
                            var description = descriptionController.text;
                            var duration = cDurationController.text;
                            var portion = portionController.text;

                            if ((imageFile == null ||
                                imageFile!.path.isEmpty) &&
                                title.isEmpty &&
                                description.isEmpty &&
                                duration.isEmpty &&
                                portion.isEmpty &&
                                currentMaterialHtml.isEmpty &&
                                currentStepHtml.isEmpty) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              if (imageFile == null ||
                                  imageFile!.path.isEmpty) {
                                var model = RecipeModel(
                                  recipeId: recipeId,
                                  photoUrl: "",
                                  title: title,
                                  description: description,
                                  duration: int.parse(duration.isEmpty ? '0' : duration),
                                  portion: int.parse(portion.isEmpty ? '0' : portion),
                                  material: currentMaterialHtml,
                                  step: currentStepHtml,
                                  uploaderId: userUid,
                                  status: "not publish",
                                );
                                addRecipe(model).then((value) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }).onError((error, stackTrace) {
                                  Fluttertoast.showToast(
                                    msg: error.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                });
                              } else {
                                uploadImage(File(imageFile!.path), recipeId.toString())
                                    .then((value) {
                                  if (value.error == null &&
                                      value.url?.isNotEmpty == true) {
                                    var model = RecipeModel(
                                        recipeId: recipeId,
                                        photoUrl: value.url ?? "",
                                        title: title,
                                        description: description,
                                        duration: int.parse(duration.isEmpty ? '0' : duration),
                                        portion: int.parse(portion.isEmpty ? '0' : portion),
                                        material: currentMaterialHtml,
                                        step: currentStepHtml,
                                        uploaderId: userUid,
                                        status: "not publish");
                                    addRecipe(model).whenComplete(() {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                          msg: "Unggahan Berhasil",
                                          toastLength: Toast.LENGTH_SHORT);
                                    });
                                  } else {
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            }
                          },
                          icon: const Icon(Icons.chevron_left),
                          style: const ButtonStyle(
                              shape: MaterialStatePropertyAll(CircleBorder())),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialogs(context);
                          var recipeId = DateTime.now().microsecondsSinceEpoch;
                          var title = titleController.text;
                          var description = descriptionController.text;
                          var duration = cDurationController.text;
                          var portion = portionController.text;

                          if (imageFile == null ||
                              imageFile!.path.isEmpty ||
                              title.isEmpty ||
                              description.isEmpty ||
                              duration.isEmpty ||
                              portion.isEmpty ||
                              currentMaterialHtml.isEmpty ||
                              currentStepHtml.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Data resep belum lengkap",
                                toastLength: Toast.LENGTH_SHORT);
                            Navigator.pop(context);
                          } else {
                            uploadImage(File(imageFile!.path), recipeId.toString()).then((value) {
                              if (value.error == null &&
                                  value.url?.isNotEmpty == true) {
                                var model = RecipeModel(
                                    recipeId: recipeId,
                                    photoUrl: value.url ?? "",
                                    title: title,
                                    description: description,
                                    duration: int.parse(duration),
                                    portion: int.parse(portion),
                                    material: currentMaterialHtml,
                                    step: currentStepHtml,
                                    uploaderId: userUid,
                                    status: "publish");
                                addRecipe(model).whenComplete(() {
                                  Navigator.pop(context);

                                  titleController.clear();
                                  descriptionController.clear();
                                  cDurationController.clear();
                                  portionController.clear();

                                  Fluttertoast.showToast(
                                    msg: "Unggahan Berhasil",
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                  setState(() {
                                    imageFile = image_picker.XFile('');
                                    currentMaterialHtml = "";
                                    currentStepHtml = "";
                                  });
                                });
                              }
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.all(15)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0))),
                        ),
                        child: const Text(
                          "Terbitkan",
                          style: TextStyle(
                            fontFamily: mainFont,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 24.0),
                child: Text(
                  "Judul Resep",
                  style: TextStyle(
                      fontFamily: mainFont, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                child: DottedBorder(
                  color: Colors.black38,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  dashPattern: const [8, 2],
                  radius: const Radius.circular(10.0),
                  child: TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontFamily: mainFont),
                    cursorColor: mainColor,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Masukkan Nama Resep",
                        hintStyle: TextStyle(
                            color: Colors.black38, fontFamily: mainFont),
                        contentPadding: EdgeInsets.all(8.0)),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 24.0),
                child: Text(
                  "Deskripsi Singkat",
                  style: TextStyle(
                      fontFamily: mainFont, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                child: DottedBorder(
                  color: Colors.black38,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  dashPattern: const [8, 2],
                  radius: const Radius.circular(10.0),
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    style: const TextStyle(fontFamily: mainFont),
                    cursorColor: mainColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Masukkan Deskripsi Resep",
                      hintStyle: TextStyle(
                          color: Colors.black38, fontFamily: mainFont),
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 24.0),
                        child: Text(
                          "Durasi Memasak",
                          style: TextStyle(
                            fontFamily: mainFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0),
                        child: DottedBorder(
                          color: Colors.black38,
                          strokeWidth: 1,
                          borderType: BorderType.RRect,
                          dashPattern: const [8, 2],
                          radius: const Radius.circular(10.0),
                          child: SizedBox(
                            width: 151,
                            child: TextFormField(
                              controller: cDurationController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontFamily: mainFont),
                              cursorColor: mainColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 24.0),
                        child: Text(
                          "Banyak Porsi",
                          style: TextStyle(
                              fontFamily: mainFont,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 4.0,
                        ),
                        child: DottedBorder(
                          color: Colors.black38,
                          strokeWidth: 1,
                          borderType: BorderType.RRect,
                          dashPattern: const [8, 2],
                          radius: const Radius.circular(10.0),
                          child: SizedBox(
                            width: 151,
                            child: TextFormField(
                              controller: portionController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontFamily: mainFont),
                              cursorColor: mainColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 24.0),
                child: Text(
                  "Bahan-bahan",
                  style: TextStyle(
                      fontFamily: mainFont, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditorScreen(text: currentMaterialHtml.isNotEmpty ? currentMaterialHtml : ""),
                    ),
                  );

                  if (!mounted) return;

                  setState(() {
                    currentMaterialHtml = result;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 4.0,
                    bottom: 8.0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: DottedBorder(
                      color: Colors.black38,
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      dashPattern: const [8, 2],
                      radius: const Radius.circular(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HtmlWidget(
                          currentMaterialHtml.isNotEmpty
                              ? currentMaterialHtml
                              : materialHtml,
                          textStyle: TextStyle(
                              fontFamily: mainFont,
                              color: currentMaterialHtml.isNotEmpty ? Colors.black : Colors.black54
                          ),
                        )
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 24.0,
                ),
                child: Text(
                  "Langkah-langkah",
                  style: TextStyle(
                    fontFamily: mainFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditorScreen(text: currentStepHtml.isNotEmpty ? currentStepHtml : ""),
                    ),
                  );
                  if (!mounted) return;

                  setState(() {
                    currentStepHtml = result;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 4.0,
                    bottom: 8.0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: DottedBorder(
                      color: Colors.black38,
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      dashPattern: const [8, 2],
                      radius: const Radius.circular(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HtmlWidget(
                          currentStepHtml.isNotEmpty
                              ? currentStepHtml
                              : stepHtml,
                          textStyle: TextStyle(
                            fontFamily: mainFont,
                            color: currentStepHtml.isNotEmpty ? Colors.black : Colors.black54
                          ),
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

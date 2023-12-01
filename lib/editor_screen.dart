import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:recipient/util.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  HtmlEditorController controller =
      HtmlEditorController(processInputHtml: true, processOutputHtml: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: mainColor,
        onPressed: () {
          var data = controller.getText();
          Navigator.pop(context, data);
        },
        child: const Icon(Icons.code_off_outlined),
      ),
      body: SafeArea(
        child: HtmlEditor(
          htmlEditorOptions: HtmlEditorOptions(
            initialText: widget.text
          ),
          controller: controller,
        ),
      ),
    );
  }
}

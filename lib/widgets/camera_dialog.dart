import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto_app/widgets/button_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraDialog extends StatefulWidget {
  final Function(File) saveFile;

  const CameraDialog({
    Key? key,
    required this.saveFile,
  }) : super(key: key);

  @override
  State<CameraDialog> createState() => _CameraDialogState();
}

class _CameraDialogState extends State<CameraDialog> {
  late XFile imageFile;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ButtonCamera(
              text: 'Camera',
              icon: Icons.camera_alt,
              onTap: _getFromCamera,
            ),
            ButtonCamera(
              text: 'Galery',
              icon: Icons.collections,
              onTap: selectId,
            )
          ],
        ),
      ),
    );
  }

  selectId() async {
    final ImagePicker picker = ImagePicker();
    try {
      await picker.pickImage(source: ImageSource.gallery).then((XFile? file) {
        if (file != null) {
          setState(() => imageFile = file);
          widget.saveFile(File(file.path));
        }
      });
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  _getFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      await picker.pickImage(source: ImageSource.camera).then((XFile? file) {
        if (file != null) {
          setState(() => imageFile = file);
          widget.saveFile(File(file.path));
        }
      });
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }
}

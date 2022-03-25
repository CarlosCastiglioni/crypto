import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? image;
  Size? size;

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  _loadCameras() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    } on CameraException catch (e) {
      BotToast.showText(text: e.description.toString());
    }
  }

  _startCamera() {
    if (cameras.isEmpty) {
      BotToast.showText(text: "Camera not found");
    } else {
      _previewCamera(cameras.first);
    }
  }

  _previewCamera(CameraDescription camera) async {
    final CameraController cameraController = CameraController(
        camera, ResolutionPreset.low,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
    controller = cameraController;

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      BotToast.showText(text: e.description.toString());
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal ID"),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: _fileWidget(),
        ),
      ),
      floatingActionButton: (image != null)
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pop(context),
              label: const Text("Finish"),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _fileWidget() {
    return Container(
      width: size!.width - 50,
      height: size!.height - (size!.height / 3),
      child: image == null
          ? _cameraPreviewWidget()
          : Image.file(
              File(image!.path),
              fit: BoxFit.contain,
            ),
    );
  }

  _cameraPreviewWidget() {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      const Center(child: CircularProgressIndicator());
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CameraPreview(controller!),
          _captureButtonWidget(),
        ],
      );
    }
  }

  _captureButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.black.withOpacity(0.5),
        child: IconButton(
          onPressed: takePhoto,
          icon: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  takePhoto() async {
    final CameraController? cameraController = controller;
    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        XFile file = await cameraController.takePicture();
        if (mounted) setState(() => image = file);
      } on CameraException catch (e) {
        BotToast.showText(text: e.description.toString());
      }
    }
  }
}

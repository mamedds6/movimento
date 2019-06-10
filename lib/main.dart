import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: CameraApp(title: 'Camera Overlay Test'),
    );
  }
}

class CameraApp extends StatefulWidget {
    CameraApp({Key key, this.title}) : super(key: key);
   
   final String title;

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar( 
      title: Text(widget.title)
      ), 
    body: Center(
      child:  new Stack(
        alignment: FractionalOffset.center,
        children: <Widget>[
            new Positioned.fill(
              child: new AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: new CameraPreview(controller)),
            ),
            new Positioned.fill(
              child: new Opacity(
                opacity: 0.3,
                child: new Image.network(
                  'https://picsum.photos/3000/4000',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
     );
  
    // if (!controller.value.isInitialized) {
    //   return Container();
    // }
    // return AspectRatio(
    //     aspectRatio:
    //     controller.value.aspectRatio,
    //     child: CameraPreview(controller));
  }
}
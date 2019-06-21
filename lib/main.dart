import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';

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
  var _myOpacity = 0.9;
  var _myAngle = 0;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
      });
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
              child: new AnimatedOpacity(
                opacity: _myOpacity,
                duration: new Duration(seconds: 3),
                child: new Image.network(
                  'https://picsum.photos/3000/4000',
                  fit: BoxFit.fill
                ),),),
            new Positioned.fill(
              child: new Stack(
                children: <Widget>[
                  new Positioned(
                    bottom: 20,
                    left: 20,
                    height: 300,          
                    child: FlutterLogo(),
                  ),
                  new Transform.rotate(
                      angle: _myAngle*(2*3.14)/360,              
                      origin: new Offset(0, 200),        
                      child: new Text("data"),
                    ),
                  new RaisedButton(
                    onPressed: () {
                      setState(() {
                        _myOpacity = 0.0;
                      });
                    },
                    color: Color.fromARGB(111, 240, 235, 250),
                    elevation: 30,
                    highlightElevation: 80,
                    disabledElevation: 20,
                    clipBehavior: Clip.antiAlias,
                    child: Text("button"),
                  )
                ],
              ) 
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
           _myOpacity +=0.1; 
           _myAngle +=30;
          });
        },        
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
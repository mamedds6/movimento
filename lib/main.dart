import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sensors/sensors.dart';


List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

  var _userAccelerometerEvents;
  var _userAccelerometerEventChannel;
  var _listToUserAccelerometerEvent;
  
Stream<UserAccelerometerEvent> get userAccelerometerEvents {
  if (_userAccelerometerEvents == null) {
    _userAccelerometerEvents = _userAccelerometerEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) =>
            _listToUserAccelerometerEvent(event.cast<double>()));
  }
  return _userAccelerometerEvents;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: CameraApp(title: 'Camera Overlay!'),
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
  CameraController cameraController;
  var _myOpacity = 0.89;
  var _myAngle = 0;
  // var _compassX = new AccelerometerEvent(0,0,0).x;
  // var _compassY = new AccelerometerEvent(0,0,0).y;
  var _compassX;
  var _compassY;

  @override
  void initState() {
    super.initState();
      accelerometerEvents.listen((event) {
        _compassX = -event.x;
        _compassY = -event.y;
      });
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
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
                  aspectRatio: cameraController.value.aspectRatio,
                  child: new CameraPreview(cameraController)),
            ),
            new Positioned.fill(
              child: new AnimatedOpacity(
                opacity: _myOpacity,
                duration: new Duration(seconds: 2),
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
                  new Positioned(                        
                    top: 100,
                    left: 100,
                    child: new Transform.rotate(
                      angle: _myAngle*(2*3.14)/360,              
                      origin: new Offset(50, 150),        
                      child: new Text("TEXT"),
                    ),
                  ),
                  new Positioned(
                    top: 20,
                    right: 20,
                    child: Text(
                    _compassX.toString()+"\n"+_compassY.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontFamily: "Arial", fontSize: 20, color: Color.fromARGB(255, 200 ,240, 220)),
                    ),
                  ),
                  new RaisedButton(
                    onPressed: () async {                        
                      accelerometerEvents.listen((event) { 
                        setState(() {});
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
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _myOpacity = 0.0;
                    _myAngle -= 20;
                  });
                },        
                  tooltip: 'Switch camera',
                  child: Icon(Icons.switch_camera),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_myOpacity <0.9)
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
    // }comment made from xiaomi hehe .. i wonder if yoy watch this... 123
    // return AspectRatio(
    //     aspectRatio:
    //     controller.value.aspectRatio,
    //     child: CameraPreview(controller));
  }
}
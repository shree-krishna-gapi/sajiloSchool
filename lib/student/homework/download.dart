import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'field/service/downloadService.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/api.dart';
import 'dart:isolate';
import 'dart:ui';

import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
const debug = false;
class Download extends StatelessWidget {
  Download({this.subject,this.description});
  final String subject; final String description;
  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return Download1(platform: platform,subject: subject,description:description);
  }
}

class Download1 extends StatefulWidget {
  final TargetPlatform platform;
  final String subject; final String description;
  Download1({Key key, this.platform, this.subject, this.description}) : super(key: key);
  @override
  _Download1State createState() => _Download1State();
}

class _Download1State extends State<Download1> {
//  final _videos = [
//    {
//      'name': 'Big Buck Bunny',
//      'link':
//      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
//    }
//  ];

  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  bool loading = true;
//  getDownload()async {
//    String url = "${Urls.BASE_API_URL}/Login/GetHomeworksDetails?schoolId=1&homeworkId=19";
//    try {
//      final response =
//          await http.get(url);
//      if (response.body != null) {
////        _videos = jsonDecode(response.body);
//        setState(() {
//          var a = jsonDecode(response.body);
//          var b = jsonEncode(a);
//          _videos = jsonEncode(a);
//        });
//        print('_videos : $_videos');
//      } else {
//        print("Error getting school.");
//      }
//    } catch (e) {
//      print("Error getting school. $e");
//    }
//  }
  @override
  void initState() {
    super.initState();
//    getDownload();
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
  int a;
  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Homework '),
//        backgroundColor: Colors.blue[800],
      ),
      body:
      Container(
        child: Column(
          children: <Widget>[
            Container(

              width: double.infinity,
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
//                          Text(' ',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                          Text(widget.subject,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                        ],
                      )),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Align( alignment: Alignment.center,
                    child: Text('${widget.description}'),
                  ),SizedBox(height: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Files',style: TextStyle(fontWeight: FontWeight.w500),),
                      Container(height: 1.5, color: Colors.black54,width: 30,)
                    ],
                  )
                ],
              ),
            ),

            Expanded(
              child: FutureBuilder<List<DownloadFile>>(
                  future: FetchDownload(http.Client()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) ;
                    if(snapshot.hasData) {
                      return snapshot.data.length > 0 ?
                      ListView.builder(
                          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Column(
                                children: <Widget>[


                                  Row(
                                    children: <Widget>[
                                      Container(width:35, child: Align(alignment:Alignment.center,child: Text('${index+1}.',style: TextStyle(color: Colors.black),)),
                                      ),
                                      Expanded(child: Test(link:'${snapshot.data[index].fileLocation}'),flex: 4,),
                                      Expanded(child: InkWell(
                                          onTap: (){
                                            _requestDownload(snapshot.data[index].fileLocation);

                                            print('${snapshot.data[index].fileLocation}');

                                          },
                                          child: Icon(Icons.file_download,color: Colors.orange, size: 24,)),flex: 1,)

                                    ],
                                  ),SizedBox(height: 12,),
                                ]

                            );
                          }

                      ) : FadeAnimation(
                        0.4, Align(
                          alignment: Alignment.center,
                          child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                            letterSpacing: 0.4,),)
                      ),
                      );
                    }
                    else {
                      return Align(child: Loader(),alignment: Alignment.center,);
                    }
                  }

              ),
            ),
          ],
        ),
      )


    );
  }
  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return new RawMaterialButton(
        onPressed: () {
          _requestDownload(task);
        },
        child: new Icon(Icons.file_download),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return new RawMaterialButton(
        onPressed: () {
          _pauseDownload(task);
        },
        child: new Icon(
          Icons.pause,
          color: Colors.red,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return new RawMaterialButton(
        onPressed: () {
          _resumeDownload(task);
        },
        child: new Icon(
          Icons.play_arrow,
          color: Colors.green,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text(
            'Ready',
            style: new TextStyle(color: Colors.green),
          ),
          RawMaterialButton(
            onPressed: () {
              _delete(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.red[400],
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return new Text('Canceled', style: new TextStyle(color: Colors.red[400]));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text('Failed', style: new TextStyle(color: Colors.red[400])),
          RawMaterialButton(
            onPressed: () {
              _retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green[400],
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      return null;
    }
  }

  void _requestDownload(task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int schoolId = prefs.getInt('schoolId');
    String urll ="${Urls.BASE_API_URL}/login/getfile?schoolid=$schoolId&filepath=$task";
    print(urll);
    task.taskId = await FlutterDownloader.enqueue(
        url: urll,
//        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
//    print(task.taskId);
  }


  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
//      PermissionStatus permission = await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.storage);
      var status = await Permission.camera.status;
      if (status.isUndetermined) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
          Permission.storage,
        ].request();
        print(statuses[Permission.location]);

//        Map<PermissionGroup, PermissionStatus> permissions =
//        await PermissionHandler()
//            .requestPermissions([PermissionGroup.storage]);
//        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
//          return true;
//        }

      } else {
        return true;
      }
    } else {
      return true;
    }
    return true;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    _tasks = [];
    _items = [];
    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

class Test extends StatefulWidget {
  Test({this.link});
  final String link;
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  String finalFileName;
  String fileName = 'loading...';
  @override
  void initState() {
    task();
    super.initState();
  }
  task() {
    var tt = widget.link.split('/');
    var count=tt.length;
    var string = tt[count-1];
    var filename= string.split('_');
    var fileCount= filename.length;
    finalFileName= filename[fileCount-1];

    setState(() {
      fileName = finalFileName;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Text('File Name:  $finalFileName');
  }
}
class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}


import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import '../data_resourse/send_and_recive_messages.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecording{
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  String _filePath = "";
   /////////////Initilized Recording////////////

   Future init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;

      if (hasPermission) {
        Directory appDocDirectory;
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
       String customPath = appDocDirectory.path +
            "/" +
            DateTime.now().millisecondsSinceEpoch.toString()
           ;

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder = FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);

        await _recorder!.initialized;
        // after initialization
        var current = await _recorder!.current(channel: 0);
        print("///////////////////////////////////////////////////");
        print(current);
        // should be "Initialized", if all working fine
          _current = current;
          _currentStatus = current!.status!;
        //  _filePath = customPath;
          print(_currentStatus);

      } else {
     print("You must accept permissions");
      }
    } catch (e) {
      print("Exception In Recording");
      print(e);
    }
  }
 //////////////////Start Recording/////////////

  start() async {
    try {
      await _recorder!.start();
      var recording = await _recorder!.current(channel: 0);
        _current = recording;


      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder!.current(channel: 0);
        // print(current.status);
          _current = current;
          _filePath = _current!.path!;
          _currentStatus = _current!.status!;

      });
    } catch (e) {
      print("Exception In Start Recording");
      print(e);
    }
  }

  ////////////////// Stop Recording /////////////////
  stop() async {
       var result =  await _recorder!.stop();
  //  print("Stop recording: ${result!.path}");
    // print("Stop recording: ${result.duration}");
    // //File file = widget.localFileSystem.file(result.path);
    // print("File length");
    // //setState(() {
      _current = result;
      _currentStatus = _current!.status!;
   // });
  }

  //////////////////////// Upload to FireStore ////////////////////
 uploadAudio ({final reciverName,final reciverId})async{
       print("Upload Audio");
       print(_filePath);
    var value1;
      // _filePath!.path;
    FirebaseStorage _fireStore = await FirebaseStorage.instance;
     try {
      final filename = _filePath.split("/").last;
     final ref= _fireStore.ref("audio/$filename");
      File audio = await File(_filePath);
       audio.exists().then((value) => print(value));
     final task= ref.putFile(audio).then((value){
        value.ref.getDownloadURL().then(
              (value) {
               ManageMessages.sendMessages(
                   reciverId: reciverId,
                   reciverName: reciverName,
                   textMessage: value,
                   isText: false);

              }
      );

     });

    }catch(e){
      print("Exception In audio Upload");
      print(e);
    }


 }


 }




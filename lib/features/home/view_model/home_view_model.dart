import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lilac_machine_test/app_config/utilities.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:convert';



class HomeViewModel with ChangeNotifier {
  bool loading = false;

  Future<bool> downloadVideo({required String path, required context}) async {
    Dio dio = Dio();
    String dirLoc = "";

    loading = true;
    notifyListeners();

    if (Platform.isAndroid) {
      dirLoc = "/sdcard/download/";
    } else {
      dirLoc = '${(await getApplicationDocumentsDirectory()).path}/';
    }
    try {
      await dio.download(
        path,
        '${dirLoc}ronaldo.mp4',
      );
      await encryptFile();
      await deleteFile(File('${dirLoc}ronaldo.mp4'));
      // final response = await dio.get(path);
      // var bytes = response.data;
      // File file =  File('${dirLoc}ronaldo.mp4',);
      //
      // await file.writeAsBytes(bytes);

      loading = false;
      notifyListeners();
      Utilities.showSnackBar('Video Downloaded successfully', context);
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Success',
              body: 'Video downloaded successfully',
              actionType: ActionType.Default
          )
      );
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      Utilities.showSnackBar('Something went wrong! please ty again', context);
      return false;
    }
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  Future <File> encryptFile() async {
    File inFile = File("/sdcard/download/ronaldo.mp4");
    File outFile = File("/sdcard/download/ronaldoenc.aes");

    bool outFileExists = await outFile.exists();

    if(!outFileExists){
      await outFile.create();
    }

    final videoFileContents = inFile.readAsStringSync(encoding: latin1);

    final key = enc.Key.fromUtf8('my 32 length key................');
    final iv = enc.IV.fromLength(16);

    final encrypted = enc.Encrypter(enc.AES(key));

    final encryptedFile = encrypted.encrypt(videoFileContents, iv: iv);
    return await outFile.writeAsBytes(encryptedFile.bytes);
  }

  Future <File> decryptFile() async {
    File inFile = File("/sdcard/download/ronaldoenc.aes");
    File outFile = File("/sdcard/download/ronaldo.mp4");

    bool outFileExists = await outFile.exists();

    if(!outFileExists){
      await outFile.create();
    }

    final videoFileContents = inFile.readAsBytesSync();

    final key = enc.Key.fromUtf8('my 32 length key................');
    final iv = enc.IV.fromLength(16);

    final encrypted = enc.Encrypter(enc.AES(key));

    final encryptedFile = enc.Encrypted(videoFileContents);
    final decrypted = encrypted.decrypt(encryptedFile, iv: iv);

    final decryptedBytes = latin1.encode(decrypted);
    return await outFile.writeAsBytes(decryptedBytes);

  }


}

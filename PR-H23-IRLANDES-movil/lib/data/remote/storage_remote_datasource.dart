import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

abstract class StorageRemoteDatasource{
  Future <String> uploadFile(File file, String destinationPath);
}

class StorageRemoteDatasourceImpl extends StorageRemoteDatasource{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(File file, String destinationPath) async {
    final uniqueName = '${DateTime.now().millisecondsSinceEpoch}-${path.basename(file.path)}';
    final ref = _storage.ref('$destinationPath/$uniqueName');
    
    final mimeType = lookupMimeType(file.path);
    await ref.putFile(file, SettableMetadata(contentType: mimeType));

    final url = await ref.getDownloadURL();
    return url;
  }
}
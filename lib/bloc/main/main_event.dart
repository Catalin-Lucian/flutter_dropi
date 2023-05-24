import 'package:cross_file/cross_file.dart';
import 'package:flutter_dropi/models/file.dart';

abstract class MainEvent {}

class GetRoot extends MainEvent {}

class GetRootContent extends MainEvent {}

class GetFolderContent extends MainEvent {
  final FileSystem fileSystem;
  GetFolderContent({required this.fileSystem});
}

class DeleteFileSystem extends MainEvent {
  final FileSystem fileSystem;
  DeleteFileSystem({required this.fileSystem});
}

class GoBack extends MainEvent {}

class AddFolder extends MainEvent {
  final String folderName;
  AddFolder({required this.folderName});
}

class AddFiles extends MainEvent {
  final Map<String, XFile> files;
  AddFiles({required this.files});
}

class Refresh extends MainEvent {}

class DownloadFile extends MainEvent {
  final FileSystem fileSystem;
  DownloadFile({required this.fileSystem});
}

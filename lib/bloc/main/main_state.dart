import 'package:flutter_dropi/models/file.dart';

class MainState {
  final FileSystem curentFolder;
  final List<FileSystem> curentContent;

  final bool isLoading;

  MainState({
    required this.curentFolder,
    required this.curentContent,
    this.isLoading = false,
  });

  MainState copyWith({
    FileSystem? curentFolder,
    List<FileSystem>? curentContent,
    bool? isLoading,
    List<int>? bytesFile,
  }) {
    return MainState(
      curentFolder: curentFolder ?? this.curentFolder,
      curentContent: curentContent ?? this.curentContent,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory MainState.initial() {
    return MainState(
      curentFolder: FileSystem(
        name: 'root',
        created_at: '',
        id: 0,
        is_file: false,
        parent_id: null,
      ),
      curentContent: [],
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropi/bloc/error/error_cubit.dart';
import 'package:flutter_dropi/bloc/main/main_event.dart';
import 'package:flutter_dropi/bloc/main/main_state.dart';
import 'package:flutter_dropi/repo/files_repo.dart';
import 'package:file_picker/file_picker.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final FilesRepo filesRepo;
  final ErrorCubit errorCubit;

  MainBloc({required this.filesRepo, required this.errorCubit})
      : super(MainState.initial()) {
    on<GetRoot>(_getRoot);
    on<GetRootContent>(_getRootContent);
    on<GetFolderContent>(_getFolderContent);
    on<DeleteFileSystem>(_deleteFileSystem);
    on<GoBack>(_goBack);
    on<AddFolder>(_addFolder);
    on<AddFiles>(_addFiles);
    on<DownloadFile>(_onDownloadFile);
    on<Refresh>(_onRefresh);
  }

  void _getRootContent(MainEvent event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    await filesRepo.getContent(state.curentFolder.id!).then((value) {
      emit(state.copyWith(curentContent: value, isLoading: false));
    }).catchError(
      (e) {
        errorCubit.setError(e.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void _getFolderContent(
      GetFolderContent event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    await filesRepo.getContent(event.fileSystem.id!).then((value) {
      emit(state.copyWith(
          curentFolder: event.fileSystem,
          curentContent: value,
          isLoading: false));
    }).catchError(
      (e) {
        errorCubit.setError(e.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void _deleteFileSystem(
      DeleteFileSystem event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    await filesRepo.deleteFile(event.fileSystem).then((value) {
      add(GetFolderContent(fileSystem: state.curentFolder));
    }).catchError(
      (e) {
        errorCubit.setError(e.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void _goBack(GoBack event, Emitter<MainState> emit) async {
    if (state.curentFolder.parent_id == null) {
      return;
    }
    emit(state.copyWith(isLoading: true));
    await filesRepo.getFileSystem(state.curentFolder.parent_id!).then((value) {
      emit(state.copyWith(curentFolder: value, isLoading: false));
      add(GetFolderContent(fileSystem: value));
    }).catchError(
      (e) {
        errorCubit.setError(e.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void _addFolder(AddFolder event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    await filesRepo
        .addFolder(state.curentFolder.id!, event.folderName)
        .then((value) => add(GetFolderContent(fileSystem: state.curentFolder)))
        .catchError(
      (e) {
        errorCubit.setError(e.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void _getRoot(GetRoot event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    await filesRepo.getRoot().then((value) {
      emit(state.copyWith(curentFolder: value, isLoading: false));
      add(GetRootContent());
    }).catchError(
      (e) {
        errorCubit.setError(e.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void _addFiles(AddFiles event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    await filesRepo
        .addFiles(state.curentFolder.id!, event.files)
        .then((_) => add(GetFolderContent(fileSystem: state.curentFolder)))
        .catchError(
      (e) {
        errorCubit.setError(e.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void _onRefresh(Refresh event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    await filesRepo.getContent(state.curentFolder.id!).then((value) {
      emit(state.copyWith(curentContent: value, isLoading: false));
    }).catchError(
      (e) {
        errorCubit.setError(e.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void _onDownloadFile(DownloadFile event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    await filesRepo.downloadFile(event.fileSystem.id!).then((bytes) async {
      // Display the file picker dialog
      final filePath =
          await FilePicker.platform.getDirectoryPath(dialogTitle: 'Save file');

      if (filePath == null) {
        // User canceled the file picker dialog
        return;
      }

      // Write the bytes to the selected file
      final file = File('$filePath/${event.fileSystem.name}');
      await file
          .writeAsBytes(bytes)
          .then((value) => emit(state.copyWith(isLoading: false)));
    }).catchError(
      (e) {
        errorCubit.setError(e.toString());
        emit(state.copyWith(isLoading: false));
      },
    );
  }
}

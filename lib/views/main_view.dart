// main view class contains

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropi/bloc/main/main_bloc.dart';
import 'package:flutter_dropi/bloc/main/main_event.dart';
import 'package:flutter_dropi/bloc/main/main_state.dart';
import 'package:flutter_dropi/models/file.dart';
import 'package:flutter_dropi/widgets/custom_loading_overlay.dart';
import 'package:flutter_dropi/widgets/cutom_icon_button.dart';
import 'package:flutter_dropi/widgets/file_card.dart';
import 'package:flutter_dropi/widgets/file_drop_widget.dart';
import 'package:flutter_dropi/widgets/folder_card.dart';
import 'package:flutter_dropi/widgets/folder_name_popup.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return CustomLoadingOverlay(
          isLoading: state.isLoading,
          child: Material(
            child: FileDropWidget(
              onFilesDropped: (Map<String, XFile> filesPath) {
                context.read<MainBloc>().add(AddFiles(files: filesPath));
              },
              child: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.blueGrey[900],
                    // flat surface, no shadow
                    elevation: 2,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          icon: Icons.arrow_back,
                          normalColor: Colors.transparent,
                          hoverColor: Colors.blueGrey,
                          onClick: () {
                            context.read<MainBloc>().add(GoBack());
                          },
                        ),
                        const SizedBox(width: 10),
                        Row(children: [
                          const Icon(Icons.folder, size: 30),
                          const SizedBox(width: 10),
                          Text(state.curentFolder.name),
                        ]),
                        const SizedBox(width: 10),
                        // refresh button
                        CustomIconButton(
                          icon: Icons.refresh,
                          normalColor: Colors.transparent,
                          hoverColor: Colors.blueGrey,
                          onClick: () {
                            context.read<MainBloc>().add(Refresh());
                          },
                        ),
                      ],
                    )),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => showFolderNamePopup(context),
                  mini: true,
                  child: const Icon(Icons.create_new_folder_rounded),
                ),
                body: Container(
                  color: Colors.grey[300],
                  child: ListView(
                    children: [
                      ...state.curentContent.map((file) {
                        if (file.is_file == false) {
                          return FolderCard(
                              file: file,
                              onGetFolderContent: (file) {
                                context
                                    .read<MainBloc>()
                                    .add(GetFolderContent(fileSystem: file));
                              },
                              onDeleteFolder: (file) {
                                context
                                    .read<MainBloc>()
                                    .add(DeleteFileSystem(fileSystem: file));
                              });
                        } else {
                          return FileCard(
                            file: file,
                            onDeleteFile: (FileSystem file) {
                              context
                                  .read<MainBloc>()
                                  .add(DeleteFileSystem(fileSystem: file));
                            },
                            onDownloadFile: (FileSystem file) {
                              context
                                  .read<MainBloc>()
                                  .add(DownloadFile(fileSystem: file));
                            },
                          );
                        }
                      }).toList(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showFolderNamePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return FolderNamePopup(
          onFolderNameEntered: (String folderName) {
            // Handle the entered folder name
            context.read<MainBloc>().add(AddFolder(folderName: folderName));
          },
        );
      },
    );
  }
}

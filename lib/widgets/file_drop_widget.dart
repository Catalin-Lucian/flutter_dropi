import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropi/widgets/cutom_icon_button.dart';

class FileDropWidget extends StatefulWidget {
  final Widget child;
  final Function(Map<String, XFile> filePath) onFilesDropped;

  const FileDropWidget({
    Key? key,
    required this.child,
    required this.onFilesDropped,
  }) : super(key: key);

  @override
  _FileDropWidgetState createState() => _FileDropWidgetState();
}

class _FileDropWidgetState extends State<FileDropWidget> {
  final Map<String, XFile> _list = {};
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (DropDoneDetails detail) async {
        setState(() {
          var files = detail.files;
          files.removeWhere((element) =>
              File(element.path).statSync().type != FileSystemEntityType.file);
          for (var element in files) {
            _list[element.name] = element;
          }
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Stack(
        children: [
          widget.child,
          if (_list.isEmpty && _dragging)
            Container(
              color: Colors.blueGrey.withOpacity(0.5),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text(
                  'Drop files here',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          if (_list.isNotEmpty)
            Container(
                color: Colors.blueGrey,
                width: double.infinity,
                height: double.infinity,
                // list wiew of files cards with icon, name and delete button, and at buttom 2 buttons: cancel and upload
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(
                                Icons.file_present_rounded,
                                color: Colors.white,
                                size: 35,
                              ),
                              title: Text(
                                _list.keys.elementAt(index),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 8),
                                  CustomIconButton(
                                      icon: Icons.delete,
                                      normalColor: Colors.transparent,
                                      hoverColor: Colors.red,
                                      onClick: () {
                                        setState(() {
                                          _list.remove(
                                              _list.keys.elementAt(index));
                                        });
                                      }),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                _list.clear();
                              });
                            },
                            color: Colors.red[400],
                            hoverColor: Colors.red[700],
                            child: Text('Cancel',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                widget.onFilesDropped({..._list});
                                _list.clear();
                              });
                            },
                            color: Colors.green[400],
                            hoverColor: Colors.green[700],
                            child: Text('Upload',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
        ],
      ),
    );
  }
}

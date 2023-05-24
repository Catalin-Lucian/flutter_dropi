import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropi/models/file.dart';
import 'package:flutter_dropi/widgets/cutom_icon_button.dart';

class FolderCard extends StatefulWidget {
  const FolderCard(
      {Key? key,
      required this.file,
      required this.onGetFolderContent,
      required this.onDeleteFolder})
      : super(key: key);

  final FileSystem file;
  final Function(FileSystem) onGetFolderContent;
  final Function(FileSystem) onDeleteFolder;

  @override
  _FolderCardState createState() => _FolderCardState();
}

class _FolderCardState extends State<FolderCard> {
  bool isHovered = false;
  DateTime? lastTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (PointerHoverEvent event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (PointerExitEvent event) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onDoubleTap: () => widget.onGetFolderContent(widget.file),
        child: Card(
          color: isHovered ? Colors.blueGrey[200] : Colors.grey[300],
          elevation: 0,
          child: ListTile(
            leading: Icon(
              Icons.folder,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
            title: Text(
              widget.file.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              widget.file.created_at,
              style: TextStyle(fontSize: 13),
            ),
            trailing: isHovered
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconButton(
                        icon: Icons.arrow_forward,
                        normalColor: Colors.blueGrey,
                        hoverColor: Colors.green,
                        onClick: () => widget.onGetFolderContent(widget.file),
                      ),
                      SizedBox(width: 8),
                      CustomIconButton(
                        icon: Icons.delete,
                        normalColor: Colors.blueGrey,
                        hoverColor: Colors.red,
                        onClick: () => showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: Text('Warning'),
                            content: Text('Do you really want to delete?'),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.green),
                                onPressed: () {
                                  Navigator.pop(c, false);
                                  widget.onDeleteFolder(widget.file);
                                },
                                child: Text('Yes'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.red),
                                child: Text('No'),
                                onPressed: () => Navigator.pop(c, false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(mainAxisSize: MainAxisSize.min, children: const [
                    SizedBox(width: 35),
                    SizedBox(width: 8),
                    SizedBox(width: 35)
                  ]),
          ),
        ),
      ),
    );
  }
}

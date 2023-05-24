import 'package:flutter/material.dart';

class FolderNamePopup extends StatefulWidget {
  final Function(String) onFolderNameEntered;

  const FolderNamePopup({Key? key, required this.onFolderNameEntered})
      : super(key: key);

  @override
  _FolderNamePopupState createState() => _FolderNamePopupState();
}

class _FolderNamePopupState extends State<FolderNamePopup> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Folder Name'),
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(hintText: 'Folder Name'),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String folderName = _textEditingController.text.trim();
            if (folderName.isNotEmpty) {
              widget.onFolderNameEntered(folderName);
              Navigator.pop(context);
            }
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

class ChatMessageInput extends StatefulWidget {
  ChatMessageInput({Key key, @required this.onSubmitted})
      : assert(onSubmitted != null),
        super(key: key);

  final ValueChanged<String> onSubmitted;

  @override
  State<StatefulWidget> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final TextSelection _defaultTextSelection =
      TextSelection.collapsed(offset: 0);

  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 4,
                ),
                child: TextField(
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.send,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  onSubmitted: (_) => _onSubmitted(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.blue),
              onPressed: () => _onSubmitted(),
            ),
          ],
        ),
      );

  void _onSubmitted() {
    final inputtedText = _textEditingController.text.trim();

    if (inputtedText.length > 0) {
      widget.onSubmitted(inputtedText);

      _textEditingController.clear();
      _textEditingController.selection = _defaultTextSelection;
    }

    FocusScope.of(context).requestFocus(_focusNode);
  }
}

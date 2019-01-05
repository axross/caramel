import 'package:caramel/domains.dart';
import 'package:flutter/material.dart';

class ChatMessageInput extends StatefulWidget {
  const ChatMessageInput({
    @required this.chatParticipation,
    Key key,
  })  : assert(chatParticipation != null),
        super(key: key);

  final ChatParticipation chatParticipation;

  @override
  State<StatefulWidget> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final TextSelection _defaultTextSelection =
      const TextSelection.collapsed(offset: 0);

  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
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
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  onSubmitted: (_) => _onSubmitted(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: _onSubmitted,
            ),
          ],
        ),
      );

  void _onSubmitted() {
    final inputtedText = _textEditingController.text.trim();

    if (inputtedText.isNotEmpty) {
      widget.chatParticipation.postText(inputtedText);

      _textEditingController
        ..clear()
        ..selection = _defaultTextSelection;
    }

    FocusScope.of(context).requestFocus(_focusNode);
  }
}

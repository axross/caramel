import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/chat_model.dart';

class ChatMessageAdder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatMessageAdderState();
}

class _ChatMessageAdderState extends State<ChatMessageAdder> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    setState(() {
      _textEditingController = TextEditingController();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatModel = Provider.of<ChatModel>(context);

    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 4,
              ),
              child: TextField(
                textInputAction: TextInputAction.send,
                controller: _textEditingController,
                onSubmitted: (_) => _onSubmitted(chatModel: chatModel),
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
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () => _onSubmitted(chatModel: chatModel),
          ),
        ],
      ),
    );
  }

  void _onSubmitted({@required ChatModel chatModel}) {
    chatModel.postingText.add(_textEditingController.text);

    _textEditingController.clear();

    FocusScope.of(context).requestFocus(new FocusNode());
  }
}

import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';

class ChatModel {
  String friendlyName;
  List<Message> messages;

  ChatModel({this.friendlyName = '', this.messages = const <Message>[]});

  ChatModel addMessage(Message message) {
    var messageList = <Message>[...messages, message];
    return copyWith(messages: messageList);
  }

  ChatModel copyWith({String friendlyName, List<Message> messages}) {
    return ChatModel(
      friendlyName: friendlyName ?? this.friendlyName,
      messages: messages ?? this.messages,
    );
  }
}
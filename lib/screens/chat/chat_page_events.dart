import 'package:twilio_sample/models/chat_model.dart';

abstract class ChatPageEvent {}

class MessageAddEvent extends ChatPageEvent{
  ChatModel chatModel;

  MessageAddEvent(this.chatModel);
}
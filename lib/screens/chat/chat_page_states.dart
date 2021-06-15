import 'package:twilio_sample/models/chat_model.dart';

abstract class ChatPageState {}

class MessageLoadState extends ChatPageState {
  ChatModel chatModel;

  MessageLoadState(this.chatModel);
}

class LoadingState extends ChatPageState{}
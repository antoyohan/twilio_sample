import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';

abstract class ChatManager{
  Future getMessages();
  Future sendMessage();
  Future sendImage();
  Future leaveChannel();
  Future sendTyping();
}
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';

class ChatModel {
  final List<ChannelDescriptor> publicChannels;
  final List<ChannelDescriptor> userChannels;

  ChatModel({
    this.publicChannels = const <ChannelDescriptor>[],
    this.userChannels = const <ChannelDescriptor>[],
  });
}

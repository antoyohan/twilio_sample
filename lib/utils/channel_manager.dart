import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';

abstract class ChannelManager {
  Future addChannel(String channelName, ChannelType type);
  Future joinChannel(Channel channel);
  Future updateChannel(ChannelDescriptor channelDescriptor, String name);
  Future destroyChannel(ChannelDescriptor channelDescriptor);
}
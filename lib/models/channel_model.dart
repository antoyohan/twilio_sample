import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';

class ChannelModel {
  final List<ChannelDescriptor> publicChannels;
  final List<ChannelDescriptor> userChannels;

  ChannelModel({
    this.publicChannels = const <ChannelDescriptor>[],
    this.userChannels = const <ChannelDescriptor>[],
  });
}

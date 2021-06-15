import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';

class ChannelModel {
  final List<ChannelDescriptor> publicChannels =  <ChannelDescriptor>[];
  final List<ChannelDescriptor> userChannels =  <ChannelDescriptor>[];

  ChannelModel(List<ChannelDescriptor> pChannels , List<ChannelDescriptor> uChannels ) {
    this.publicChannels.clear();
    this.userChannels.clear();
    this.publicChannels.addAll(pChannels);
    this.userChannels.addAll(uChannels);
  }

  @override
  String toString() {
    return 'ChannelModel{publicChannels: ${publicChannels.length}, userChannels: ${userChannels.length}';
  }
}

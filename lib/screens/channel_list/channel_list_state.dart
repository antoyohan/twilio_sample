import 'package:twilio_sample/models/channel_model.dart';

abstract class ChannelListState{}

class ChannelLoading extends ChannelListState{}

class ChannelsModel extends ChannelListState {
  ChannelModel channelModel;

  ChannelsModel(this.channelModel);
}
import 'package:twilio_sample/models/chat_model.dart';

abstract class ChannelListState{}

class ChannelLoading extends ChannelListState{}

class ChannelsModel extends ChannelListState {
  ChatModel chatModel;

  ChannelsModel(this.chatModel);
}
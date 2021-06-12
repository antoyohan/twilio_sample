import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilio_sample/models/chat_model.dart';
import 'package:twilio_sample/repository/user_repository.dart';
import 'package:twilio_sample/screens/channel_list/channel_list_event.dart';
import 'package:twilio_sample/screens/channel_list/channel_list_state.dart';

const String TAG = "ChannelListBloc";

class ChannelListBloc extends Bloc<ChannelEvent, ChannelListState> {
  ChannelListBloc(ChannelListState initialState, this._userRepo)
      : super(initialState);

  ChatClient chatClient;
  UserRepoImpl _userRepo;
  ChatModel _currentChatModel;
  Map<String, int> unreadMessagesMap = {};
  Map<String, ChannelStatus> channelStatusMap = {};
  final List<StreamSubscription> _subscriptions = <StreamSubscription>[];

  @override
  Stream<ChannelListState> mapEventToState(ChannelEvent event) async* {
    developer.log("state : $state", name: TAG);
    if (event is ChannelAddEvent) {
      yield ChannelLoading();
    } else if (event is ChannelsLoaded) {
      yield ChannelsModel(_currentChatModel);
    }
  }

  Future loadChatClient() async {
    developer.log("LoadChat Client ", name: TAG);
    var properties = Properties();
    //await TwilioProgrammableChat.debug(dart: true, native: true, sdk: false);
    var token = await _userRepo.getToken();
    developer.log("token $token", name: TAG);
    chatClient = await TwilioProgrammableChat.create(token, properties);

    _subscriptions.add(chatClient.onChannelAdded.listen((event) {
      retrieve();
    }));
    _subscriptions.add(chatClient.onChannelDeleted.listen((event) {
      retrieve();
    }));
    _subscriptions.add(chatClient.onChannelUpdated.listen((event) {
      retrieve();
    }));
    _subscriptions
        .add(chatClient.onChannelSynchronizationChange.listen((event) {
      retrieve();
    }));
    _subscriptions.add(chatClient.onChannelInvited.listen((event) {
      retrieve();
    }));
    retrieve();
  }

  Future addChannel(String channelName, ChannelType type) async {
    if (type != null) {
      add(ChannelAddEvent());
      var channel = await chatClient.channels.createChannel(channelName, type);
      if (channel != null) {
        await retrieve();
      }
    }
  }

  Future joinChannel(Channel channel) {
    if (channel != null) {
      add(ChannelJoinEvent());
      channel.onSynchronizationChanged.listen((event) {
        retrieve();
      });
      channel.join();
    }
  }

  Future updateChannel(ChannelDescriptor channelDescriptor, String name) async {
    var channel = await channelDescriptor.getChannel();
    if (channel != null) {
      await channel.setFriendlyName(name);
      await retrieve();
    }
  }

  Future destroyChannel(ChannelDescriptor channelDescriptor) async {
    try {
      var channel = await channelDescriptor.getChannel();
      if (channel != null) {
        await channel.destroy();
        await retrieve();
      }
    } catch (e) {
      //todo
    }
  }

  Future retrieve() async {
    developer.log("retreive ", name: TAG);
    var userChannelPaginator = await chatClient.channels.getUserChannelsList();
    var publicChannelPaginator =
        await chatClient.channels.getPublicChannelsList();
    _currentChatModel = ChatModel(
        publicChannels: publicChannelPaginator.items,
        userChannels: userChannelPaginator.items);
    add(ChannelsLoaded());
  }

  Future _updateMessageCountForChannel(
      ChannelDescriptor channelDescriptor) async {
    var userHasJoined =
        (await channelDescriptor.status) == ChannelStatus.JOINED;
    if (!userHasJoined) {
      unreadMessagesMap[channelDescriptor.sid] =
          channelDescriptor.messagesCount;
    } else {
      unreadMessagesMap[channelDescriptor.sid] =
          await channelDescriptor.unconsumedMessagesCount;
    }
  }

  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    _subscriptions.clear();
  }
}

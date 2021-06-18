import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilio_sample/models/chat_model.dart';
import 'package:twilio_sample/models/media_model.dart';
import 'package:twilio_sample/screens/chat/chat_page_events.dart';
import 'package:twilio_sample/screens/chat/chat_page_states.dart';

const String TAG = "Chat Bloc";

class ChatBloc extends Bloc<ChatPageEvent, ChatPageState> {
  TextEditingController messageController = TextEditingController();
  String myUsername;
  ChatClient chatClient;
  String tempDirPath;
  Channel channel;
  ChannelDescriptor channelDescriptor;
  Map<String, BehaviorSubject<MediaModel>> mediaSubjects =
      <String, BehaviorSubject<MediaModel>>{};
  BehaviorSubject<String> _typingSubject;
  ValueStream<String> typingStream;
  final ImagePicker _imagePicker = ImagePicker();
  BehaviorSubject<ChatModel> _messageSubject;
  ValueStream<ChatModel> messageStream;
  List<StreamSubscription> _subscriptions;
  ScrollController scrollController = ScrollController();

  ChatBloc(ChatPageState initialState,{ this.myUsername, this.channelDescriptor,
      this.chatClient})
      : super(initialState) {
    _messageSubject = BehaviorSubject<ChatModel>();
    _messageSubject.add(ChatModel());
    _typingSubject = BehaviorSubject<String>();
    typingStream = _typingSubject.stream;
    messageStream = _messageSubject.stream;
    channelDescriptor.getChannel().then((channel) {
      this.channel = channel;
      _subscribeToChannel();
    });
    messageController.addListener(() {
      _onTyping();
    });
    _subscriptions = <StreamSubscription>[];
  }

  @override
  Stream<ChatPageState> mapEventToState(ChatPageEvent event) async* {
    if (event is MessageAddEvent) {
      yield MessageLoadState(event.chatModel);
    }
    throw UnimplementedError();
  }

  Future _subscribeToChannel() async {
    developer.log("subscribeToChannel", name: TAG);
    if (channel.hasSynchronized) {
      await _getMessages(channel);
    }
    _subscriptions.add(channel.onSynchronizationChanged.listen((event) async {
      if (event.synchronizationStatus == ChannelSynchronizationStatus.ALL) {
        await _getMessages(event);
      }
    }));
    _subscriptions.add(channel.onMessageAdded.listen((Message message) {
      _messageSubject.add(_messageSubject.value.addMessage(message));
      if (message.hasMedia) {
        _getImage(message);
      }
    }));
    channel.onTypingStarted.listen((TypingEvent event) {
      _typingSubject.add(event.member.identity);
    });
    channel.onTypingEnded.listen((TypingEvent event) {
      _typingSubject.add(null);
    });
  }

  Future _getMessages(Channel channel) async {
    developer.log("getMessages", name: TAG);
    var friendlyName = await channel.getFriendlyName();
    var messageCount = await channel.getMessagesCount();
    var messages = await channel.messages.getLastMessages(messageCount);
    developer.log("getMessages $friendlyName  $messageCount ${messages.length}", name: TAG);
    messages.where((message) => message.hasMedia).forEach(_getImage);
    _messageSubject.add(_messageSubject.value.copyWith(
      friendlyName: friendlyName,
      messages: messages,
    ));
    await _updateLastConsumedMessageIndex(channel, messages);
  }

  Future _updateLastConsumedMessageIndex(
      Channel channel, List<Message> messages) async {
    developer.log("updateLastConsumedMessageINdex", name: TAG);
    var lastConsumedMessageIndex =
        (messages?.length ?? 0) > 0 ? messages.last.messageIndex : 0;
    await channel.messages
        .setLastConsumedMessageIndexWithResult(lastConsumedMessageIndex);
  }

  Future sendMessage() async {
    developer.log("sendMessage", name: TAG);
    var message = MessageOptions()
      ..withBody(messageController.text)
      ..withAttributes({'name': myUsername});
    await channel.messages.sendMessage(message);
  }

  Future _getImage(Message message) async {
    developer.log("getImage", name: TAG);
    var subject = BehaviorSubject<MediaModel>();
    subject.add(MediaModel(isLoading: true, message: message));
    mediaSubjects[message.sid] = subject;

    if (tempDirPath == null) {
      var tempDir = await getTemporaryDirectory();
      tempDirPath = tempDir.path;
    }
    var path = '$tempDirPath/'
        '${(message.media.fileName != null && message.media.fileName.isNotEmpty) ? message.media.fileName : message.media.sid}.'
        '${extensionFromMime(message.media.type)}';
    var outputFile = File(path);

    await message.media.download(outputFile);
    subject.add(subject.value.copyWith(isLoading: false, file: outputFile));
    subject.close();
  }

  Future sendImage() async {
    developer.log("send Image", name: TAG);
    var image = await _imagePicker.getImage(source: ImageSource.gallery);
    if (image != null) {
      var file = File(image.path);
      var mimeType = mime(image.path);
      var message = MessageOptions()
        ..withMedia(file, mimeType)
        ..withAttributes({'name': myUsername});
      await channel.messages.sendMessage(message);
    }
  }

  Future leaveChannel() async {
    developer.log("leave Channel", name: TAG);
    if (channel.type == ChannelType.PUBLIC) {
      return channel.leave();
    } else {
      await channel.leave();
      return channel.destroy();
    }
  }

  Future _onTyping() async {
    developer.log("onTyping", name: TAG);
    await channel.typing();
  }

  @override
  Future<void> close() async {
    _typingSubject.close();
    await _messageSubject.close();
    _subscriptions.forEach((s) => s.cancel());
    _subscriptions.clear();
    messageController.removeListener(_onTyping);
    return super.close();
  }
}

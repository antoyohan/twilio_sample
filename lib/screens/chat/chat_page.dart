import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilio_sample/models/chat_model.dart';
import 'package:twilio_sample/models/media_model.dart';
import 'package:twilio_sample/screens/chat/chat_bloc.dart';
import 'package:twilio_sample/screens/chat/chat_page_states.dart';
import 'package:twilio_sample/ui/chat_cards.dart';
import 'package:twilio_sample/ui/members_list_dialog.dart';

class ChatPage extends StatefulWidget {
  ChatPage(
      {Key key,
      @required this.userName,
      @required this.channelDescriptor,
      @required this.chatClient})
      : super(key: key);

  String userName;
  ChannelDescriptor channelDescriptor;
  ChatClient chatClient;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc(LoadingState(),
        channelDescriptor: widget.channelDescriptor,
        chatClient: widget.chatClient,
        myUsername: widget.userName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<ChatBloc>(
        create: (context) => chatBloc,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF5BA2DF),
            automaticallyImplyLeading: true,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  widget.channelDescriptor.friendlyName,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                )
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  _showMembersLIstDialog(widget.channelDescriptor);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Icon(
                    Icons.more_vert_sharp,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              )
            ],
            centerTitle: true,
            elevation: 4,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder<ChatModel>(
                  stream: chatBloc.messageStream,
                  initialData: null,
                  builder: (context, snapshot) {
                    var chatModel = snapshot.data;
                    if (chatModel != null && chatModel.messages.isNotEmpty) {
                      return chatList(chatModel);
                    } else if (chatModel != null &&
                        chatModel.messages.isEmpty) {
                      return Expanded(
                          child: Center(
                              child: Text(
                        "",
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )));
                    } else {
                      return Expanded(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ));
                    }
                  }),
              StreamBuilder<Object>(
                  stream: chatBloc.typingStream,
                  builder: (context, snapshot) {
                    var data = snapshot.data;
                    if (data != null && !messageFromMe(data)) {
                      return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('$data is typing...'),
                            )
                          ]);
                    } else {
                      return Container(
                        height: 0.0,
                      );
                    }
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(

                        icon: Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.cyan,
                        ),
                        onPressed: () {
                          chatBloc.sendImage();
                        }),
                    Expanded(
                      child: TextFormField(
                        controller: chatBloc.messageController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Type here..',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF5E5E5E),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF5BA2DF),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        ),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.cyan,
                      ),
                      onPressed: () async {
                        await chatBloc.sendMessage();
                        await chatBloc.scrollController.jumpTo(
                            chatBloc.scrollController.position.maxScrollExtent);
                        setState(() {
                          chatBloc.messageController.text = '';
                          FocusScope.of(context).requestFocus(FocusNode());
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Return list view
  Widget chatList(ChatModel chatModel) {
    /*if (chatBloc.scrollController.hasClients) {
      chatBloc.scrollController.animateTo(
        chatBloc.scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }*/
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return getChatCard(chatModel.messages[index]);
        },
        shrinkWrap: true,
        itemCount: chatModel.messages.length,
        controller: chatBloc.scrollController,
      ),
    );
  }

  ///Returns chat cards
  Widget getChatCard(Message message) {
    if (messageFromMe(message.author)) {
      if (message.hasMedia) {
        return getImageWidget(message, true);
      } else {
        return ChatListItemWidget(message: message);
      }
    } else {
      if (message.hasMedia) {
        return getImageWidget(message, true);
      } else {
        return AgentChatListItemWidget(message: message);
      }
    }
  }

  StreamBuilder<MediaModel> getImageWidget(Message message, bool isMe) {
    return StreamBuilder(
      stream: chatBloc.mediaSubjects[message.sid],
      initialData: MediaModel(isLoading: true, message: message),
      builder: (BuildContext context, AsyncSnapshot<MediaModel> snapshot) {
        var data = snapshot.data;
        // Set height/width on Containers to avoid jank
        if (data.isLoading) {
          return Container(
            height: 220,
            width: 220,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          print('ChannelPage => building message sid: ${message.sid} index: ${message.messageIndex} file: ${data.file.path}');
          return Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 220,
                width: 220,
                child: Image.file(
                  data.file,
                  height: 200,
                  width: 200,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  bool messageFromMe(String author) {
    return author == chatBloc.chatClient.myIdentity;
  }

  Future _showMembersLIstDialog(ChannelDescriptor channelDescriptor) async {
   var result = await showDialog(
        context: context,
        builder: (context) {
          return MembersListDialog(channelDescriptor);
        });
  }
}

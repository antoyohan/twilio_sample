# twilio_sample

This is a POC for testing Twilio Programmable chat's Flutter plugin.
[Twilio Programmable chat sdk (Flutter)](https://pub.dev/packages/twilio_programmable_chat)

### POC Overview

twilio_programmable_chat: 0.1.1+8,
Flutter: 2.0.2,
IDE: Android Studio 4.2.1

## Getting Started

## For local development
Since complete docs are not available refer Android tutorial here for reference.
[Tutorial here](https://www.twilio.com/docs/chat/tutorials/chat-application-android-java)

Twilio programmable chat client requires a access token generated using your twilio credentials.First we need to setup a server that will generate this token for the mobile application to use. We have created web versions of Twilio Chat, you can use any of the following flavours

-[JS - Node](https://github.com/TwilioDevEd/twiliochat-node)

For more server flavours have a read on [this](https://github.com/TwilioDevEd/twiliochat-android) project

Once your server is up and running. You have to change your TOKEN_URL in strings_constants.dart file in the project to your local server path.

Checkout twilio prohrammable chat tutorials [here](https://www.twilio.com/docs/chat).

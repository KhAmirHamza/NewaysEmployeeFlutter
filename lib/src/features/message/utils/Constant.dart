import 'package:flutter/material.dart';

const chatUrl = "http://116.68.198.178:5005"; //Real Server
const NEWAYS_GROUP_ID = "C1691583615779"; //Real Server

  //const chatUrl = "http://10.100.93.30:5005"; //Real Server-Local
  //const chatUrl = "http://10.100.93.84:3000"; //Local Server

  class ChatColors{
    static Color? chatBubbleBackgroundSelf = Colors.cyan[50];
    static Color? chatBubbleBackgroundParticipants = Colors.grey[200];
  }

class Constants {
  /// Default character that replace the mentions
  /// and can't be used in text field.
  static const String escapingMentionCharacter = '∞';

  /// The character used to trigger a mention.
  static const String mentionCharacter = '@';
}
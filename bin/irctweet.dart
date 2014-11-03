library irctweet;

import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'dart:convert' show JSON;
import 'package:intl/intl.dart';
import 'package:irc/irc.dart';
import 'package:oauth/oauth.dart' as oauth;

part 'tweeter.dart';
part 'src/keys.dart';

void ircTweet(TwitterKey key) {
  TweetUpdate tweeter = new TweetUpdate();
  var config = new BotConfig(host: "irc.freenode.net", nickname: "DartIRCTweetBot");
  var bot = new CommandBot(config);

  // Intl.defaultLocale = 'pt_BR';
  //initializeDateFormatting("ja_JP",null);
  var format = new DateFormat.Hms();
  var dateString = format.format(new DateTime.now());

  print("Please Input IRC Channel Name!");
  var channel_name = stdin.readLineSync();
  ;

  bot.register((ReadyEvent event) {
    event.join(channel_name);
  });

  bot.register((BotJoinEvent event) {
    print("Joined $channel_name ");
    tweeter.update(key, "Joined IRCTweet Bot $channel_name");
  });

  bot.register((QuitEvent event) {
    print("${event.user} is Quit");
    tweeter.update(key,"${event.user} Quit: $channel_name ($dateString)");
  });

  bot.register((PartEvent event) {
    print("${event.user} is left");
    tweeter.update(key,"${event.user} Left: $channel_name ($dateString)");
  });

  bot.register((JoinEvent event) {
    print("${event.user} is Join! Welcome!");
    tweeter.update(key,"${event.user} Join: $channel_name ($dateString)");
  });

  bot.connect();
}

void main() {
  File keyFile = new File('.keys');
  List<String> keys = keyFile.readAsLinesSync();
  String con_key = keys[0];
  String con_secret = keys[1];
  String acc_key = keys[2];
  String acc_secret = keys[3];
  TwitterKey key = TwitterKey.createKey(con_key, con_secret, acc_key, acc_secret);
  ircTweet(key);
}

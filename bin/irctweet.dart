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
  
  print("Please Input IRC Host!");
  var host_name = stdin.readLineSync();

  print("Please Input BOT's nickname!");
  var bot_nickname = stdin.readLineSync();

  print("Please Input IRC Channel Name!");
  var channel_name = stdin.readLineSync();


  var config = new BotConfig(host: host_name, nickname: bot_nickname);
  var bot = new CommandBot(config);

  var format = new DateFormat.Hms();

  bot.register((ReadyEvent event) {
    event.join(channel_name);
  });

  bot.register((BotJoinEvent event) {
    print("Joined $channel_name ");
    tweeter.update(key, "Joined IRCTweet Bot $channel_name");
  });

  bot.register((QuitEvent event) {
    print("${event.user} is Quit");
    tweeter.update(key,"${event.user} Quit: $channel_name (${format.format(new DateTime.now())})");
  });

  bot.register((PartEvent event) {
    print("${event.user} is left");
    tweeter.update(key,"${event.user} Left: $channel_name (${format.format(new Datetime.now())})");
  });

  bot.register((JoinEvent event) {
    print("${event.user} is Join! Welcome!");
    tweeter.update(key,"${event.user} Join: $channel_name (${format.format(new Datetime.now())})");
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

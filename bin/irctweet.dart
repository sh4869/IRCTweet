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
  var path = Platform.environment["HOME"] + "/.irctweet/setting.json";
  var key_file = new File(path);
  if(key_file.existsSync() == true){
    var key_json = JSON.decode(key_file.readAsStringSync());
    TwitterKey key = TwitterKey.createKey(key_json["consumer_key"],key_json["consumer_sercret"],
                                          key_json["access_key"],key_json["access_sercret"]);
    ircTweet(key);
  }else{
    print("setting your .irctweetrc on your home directory");
  }
}

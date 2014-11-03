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

void ircTweet(oauth.Token consumer,oauth.Token user){
  var config = new BotConfig(
      host:"irc.freenode.net",
      nickname: "DartIRCTweetBot"
      );
  var bot = new CommandBot(config);

 // Intl.defaultLocale = 'pt_BR';
  //initializeDateFormatting("ja_JP",null);
  var format = new DateFormat.Hms();
  var dateString = format.format(new DateTime.now());

  bot.register((ReadyEvent event){
    event.join("#touhu2b");
  });

  bot.register((BotJoinEvent event){
    print("Joined ${event.channel.name}");
    update(consumer,user,"Join #touhu2b ($dateString)");
  });

  bot.register((QuitEvent event){
    print("${event.user} is Quit");
    update(consumer,user,"${event.user} Quit: #touhu2b ($dateString)");
  });

  bot.register((PartEvent event){
    print("${event.user} is left");
    update(consumer,user,"${event.user} Left: #touhu2b ($dateString)");
  });

  bot.register((JoinEvent event){
    print("${event.user} is Join! Welcome!");
    update(consumer,user,"${event.user} Join: #touhu2b ($dateString)");
  });

  bot.connect();
}

void main(){
  File keyFile = new File('./keys');
  List<String> keys = keyFile.readAsLinesSync();
  String conKey = keys[0];
  String conSecret = keys[1];
  String accKey = keys[2];
  String accSecret = keys[3];
  oauth.Token consumer,user;
  consumer = createToken(conKey,conSecret);
  user = createToken(accKey,accSecret);

  ircTweet(consumer,user);
}

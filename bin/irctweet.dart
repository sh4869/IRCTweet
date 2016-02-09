library irctweet;

import 'dart:io';
import 'dart:async';
import 'dart:convert' show JSON;
import 'package:intl/intl.dart';
import 'package:irc/irc.dart';
import 'package:twitter/twitter.dart';

void ircTweet(key) {
  Twitter twitter = new Twitter(key["consumer_key"], key["consumer_sercret"],
      key["access_key"], key["access_sercret"]);

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
    twitter.request("GET", "statuses/update.json",
        body: {"status": "Joined IRCTweet Bot $channel_name"});
  });

  bot.register((QuitEvent event) {
    print("${event.user} is Quit");
    twitter.request("GET", "statuses/update.json", body: {
      "status":
          "${event.user} Quit: $channel_name (${format.format(new DateTime.now())})"
    });
  });

  bot.register((PartEvent event) {
    print("${event.user} is left");
    twitter.request("GET", "statuses/update.json", body: {
      "status":
          "${event.user} Left: $channel_name (${format.format(new Datetime.now())})"
    });
  });

  bot.register((JoinEvent event) {
    print("${event.user} is Join! Welcome!");
    twitter.request("GET", "statuses/update.json", body: {
      "status":
          "${event.user} Join: $channel_name (${format.format(new Datetime.now())})"
    });
  });

  bot.connect();
}

void setting_key() {
  print("Set Twitter API Key\n\n");
  stdout.write("Input Your Twitter Consumer Key\n>");
  var consumer_key = stdin.readLineSync();

  stdout.write("Input Your Twitter Consumer Sercret\n>");
  var consumer_sercret = stdin.readLineSync();

  stdout.write("Input Your Twitter Access Key\n>");
  var access_key = stdin.readLineSync();

  stdout.write("Input Your Twitter Access Sercret\n>");
  var access_sercret = stdin.readLineSync();
  var key_data = new Map();
  key_data["consumer_key"] = consumer_key;
  key_data["consumer_sercret"] = consumer_sercret;
  key_data["access_key"] = access_key;
  key_data["access_sercret"] = access_sercret;
  var path = Platform.environment["HOME"] + "/.irctweet/setting.json";
  var file = new File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  file.writeAsStringSync(JSON.encode(key_data));
  print("create Setting.json!!");
}

void main() {
  var path = Platform.environment["HOME"] + "/.irctweet/setting.json";
  var key_file = new File(path);
  if (key_file.existsSync() == true) {
    var key = JSON.decode(key_file.readAsStringSync());
    ircTweet(key);
  } else {
    print("setting your .irctweetrc on your home directory");
    setting_key();
  }
}

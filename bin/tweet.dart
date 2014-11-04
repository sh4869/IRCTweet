library tweet;

import 'dart:async';
import 'dart:core';
import 'dart:convert' show JSON;
import 'package:intl/intl.dart';
import 'package:irc/irc.dart';
import 'package:oauth/oauth.dart' as oauth;

part 'tweeter.dart';
part 'src/keys.dart';

void main() {
  TweetUpdate tweeter = new TweetUpdate();
  var consumer_key = 'jNITHyxuu7o0naFzu8Ru8g';
  var consumer_secret = 'rN18lZGoR3bZTof6J6aHUh5UIPfc9PAu7UpX8UTrbI';
  var access_token = '1264492400-u7kZfgwy68FdwmWrX2aFeqP3cVFcOThR5yULyU7';
  var access_secret = 'flhYVawckxhIm6O5rMntJY09LmAROwKzuK1rc8hiT9vEP';


  TwitterKey key = TwitterKey.createKey(consumer_key, consumer_secret, access_token, access_secret);
  tweeter.update(key, "Test from Dart!");
}

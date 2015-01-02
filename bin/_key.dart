part of irctweet;

/// Return Twitter API Keys
class TwitterKey {

  oauth.Token consumer;
  oauth.Token user;

  static TwitterKey createKey(String conkey,String conser,String acctoken,String accsercret) {


    oauth.Token consumer = createToken(conkey,conser);
    oauth.Token user = createToken(acctoken,accsercret);

    return new TwitterKey()
        ..consumer = consumer
        ..user = user;

  }

}


oauth.Token createToken(String key, String secret) {
  return new oauth.Token(key, secret);
}

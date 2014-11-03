part of irctweet;

class TweetUpdate {
  Future<MAP> update(TwitterKey key,String text){
    var compl = new Completer();
    var client = new oauth.Client(key.consumer);
    client.userToken = key.user;
    Map body = {"status":text};
    client.post("https://api.twitter.com/1.1/statuses/update.json",body:body)
      .then((res){
        if(res.statusCode == 200 || res.statusCode == 201){
          compl.complete(JSON.decode(res.body));
        }else{
          compl.completeError(res);
        }
      });
    return compl.future;
  }
}

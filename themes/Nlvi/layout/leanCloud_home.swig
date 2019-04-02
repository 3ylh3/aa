<script src="//cdn1.lncld.net/static/js/2.5.0/av-min.js"></script>
<script>
    var APP_ID = '0MxsPI7i0WQS8ay0kgAoKMyg-gzGzoHsz';
    var APP_KEY = 'Njk0sn0NSf7KiknnCRzlbBVS';
    AV.init({
        appId: APP_ID,
        appKey: APP_KEY
    });
    var articles = $(".leancloud_nums")
    for(var i = 0;i < articles.length;i++){
      var url = articles[i].id;
      var query = new AV.Query("xiaobai");
      query.equalTo("words", url);
      query.find().then(function (result) {
          var id = result[0].get('words');
          var number = result.length;
          $(document.getElementById(id)).text(number?  number : '0');
      }, function (error) {
            // error is an instance of AVError.
      });
    }
</script>
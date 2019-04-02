<!DOCTYPE html>
<html lang="{{ config.language }}">
<head>
  {% include "_partial/head.swig" %}
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
  <link href="https://ico.z01.com/zico.min.css" rel="stylesheet"/>
  <title>{% block title %}{% endblock %}</title>
</head>
<body>
  {% include "_partial/progress.swig" %}

  {% if theme.scheme == 'banderole' %}
    {% include "_partial/tagcloud.swig" %}
    {% include "_partial/categorycloud.swig" %}
  {% endif %}

  <div class="container" style="display:none;">

    {% include "_partial/header.swig" %}
    <div class="container-inner">
    {% if is_home() %}
    <div class="row" style="margin-left:0">
      <div class="col-4 col-sm-2" style="padding:0;">
         <div class="card text-center">
            <img class="card-img-top" width="100%" src="https://thumbnail10.baidupcs.com/thumbnail/e0a2479b8571498ad9b625513ec3e626?fid=4047388677-250528-820718639391882&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-UzD4VJ09UHwWE04yAzh%2bEpj4L%2fs%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2120012363433140132&dp-callid=0&time=1554166800&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1"/>
            <div class="card-body">
               <div class="row">
                 <div class="col" style="padding:0">
                    <p class="card_text" style="margin:0"><b>{{ site.posts.length }}</b></p>
                    <p class="card_text" style="margin:0">文章</p>
                 </div>
                 <div class="col" style="padding:0">
                    <p class="card_text" style="margin:0"><b>{{ site.categories.length }}</b></p>
                    <p class="card_text" style="margin:0">分类</p>
                 </div>
                 <div class="col" style="padding:0">
                    <p class="card_text" style="margin:0"><b>{{ site.tags.length }}</b></p>
                    <p class="card_text" style="margin:0">标签</p>
                 </div>
               </div>
               <div class="row" style="margin-top:10%;">
                  <div class="col-4">
                     <a disabled data-container="body" data-html="true" data-toggle="popover" data-placement="bottom" data-content="<img src='https://thumbnail10.baidupcs.com/thumbnail/4265290947bc6ac90915d658848d6784?fid=4047388677-250528-518831489550571&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-yZzSHJIDZB9xVitW57o0SYpJdmo%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2120164567497095735&dp-callid=0&time=1554166800&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1' width='100%'>"><i class="zi zi_tmQq"></i></a>
                  </div>
                  <div class="col-4">
                     <a disabled data-container="body" data-html="true" data-toggle="popover" data-placement="bottom" data-content="<img src='https://thumbnail10.baidupcs.com/thumbnail/7020fa5b125d5c8fd30c4da8e6ee5c7e?fid=4047388677-250528-385906149158086&rt=pr&sign=FDTAER-DCb740ccc5511e5e8fedcff06b081203-ogLpPC9gDOhPViYWc3IBT%2bFiSgU%3d&expires=8h&chkbd=0&chkv=0&dp-logid=2120164567497095735&dp-callid=0&time=1554166800&size=c1280_u720&quality=90&vuk=4047388677&ft=image&autopolicy=1' width='100%'>"><i class="zi zi_tmWeixin"></i></a>
                  </div>
                  <div class="col-4">
                     <a href="/atom.xml" style="color:black"><i class="zi zi_rss"></i></a>
                  </div>
               </div>
            </div>
         </div>
      </div>
      <div class="col-8 col-sm-10" style="padding:0">
      {% endif %}
      <main class="main" id="main">
        <div class="main-wrapper">
          {% block main %} {% endblock %}
        </div>
      </main>
      {% if is_home() %}
      </div>
      
    </div>
    {% endif %}
      {% include "./_partial/footer.swig" %}
    </div>
  </div>
  {% include "_partial/_feature/common.swig" %}
  <!-- Optional JavaScript -->
  <!-- jQuery first, then Popper.js, then Bootstrap JS -->
  <script src="https://cdn.bootcss.com/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
  <script src="https://cdn.bootcss.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
  <script>
      $(function () {
        $('[data-toggle="popover"]').popover()
      })
  </script>
  {% if is_post() %}
    {% include "leanCloud.swig" %}
  {% endif %}
  {% if is_home() %}
    {% include "leanCloud_home.swig" %}
  {% endif %}
  <script>
  (function(){
    var bp = document.createElement('script');
    var curProtocol = window.location.protocol.split(':')[0];
    if (curProtocol === 'https') {
        bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
    }
    else {
        bp.src = 'http://push.zhanzhang.baidu.com/push.js';
    }
    var s = document.getElementsByTagName("script")[0];
    s.parentNode.insertBefore(bp, s);
  })();
  </script>
</body>
</html>

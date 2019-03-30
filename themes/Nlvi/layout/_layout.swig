<!DOCTYPE html>
<html lang="{{ config.language }}">
<head>
  {% include "_partial/head.swig" %}
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="referrer" content="no-referrer"/>

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
  <link href="https://ico.z01.com/zico.min.css" rel="stylesheet"/>
  <title>{% block title %}{% endblock %}</title>
</head>
<body>
  {% include "_partial/progress.swig" %}

  {% if theme.scheme == 'banderole' %}
    {% include "_partial/tagcloud.swig" %}
  {% endif %}

  <div class="container" style="display:none;">

    {% include "_partial/header.swig" %}
    <div class="container-inner">
    {% if is_home() %}
    <div class="row" style="margin-left:0">
      <div class="col-4 col-sm-2" style="padding:0;">
         <div class="card text-center">
            <img class="card-img-top" width="100%" src="https://b-ssl.duitang.com/uploads/item/201504/23/20150423H5137_Wziwv.thumb.1300_0.jpeg"/>
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
                  <div class="col">
                     <i class="zi zi_tmQq"></i>
                  </div>
                  <div class="col">
                     <i class="zi zi_tmWeixin"></i>
                  </div>
                  <div class="col">
                     <i class="zi zi_rss"></i>
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
</body>
</html>

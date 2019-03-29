{% extends "_layout.swig" %}

{% block title %}
  {{config.title}}
  {% if config.subtitle %}
    | {{ config.subtitle }}
  {% endif %}
{% endblock %}


{% block main %}
  {% include "_partial/main.swig" %}
  <p>{{ page.total }}</p>
  {% include "_partial/pagenum.swig" %}
{% endblock %}


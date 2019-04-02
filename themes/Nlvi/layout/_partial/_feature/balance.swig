{% include "../tagcloud.swig" %}
{% include "../categorycloud.swig" %}
{% if is_post() %}
  {% include "../_post/toc.swig" %}
{% endif %}
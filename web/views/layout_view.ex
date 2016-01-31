defmodule Ginjyo.LayoutView do
  use Ginjyo.Web, :view

  def twitter_meta() do
    twitter = Application.get_env(:ginjyo, :twitter)
    if String.length(twitter) > 0 do
      "<meta name=\"twitter:card\" content=\"summary\"/>
      <meta name=\"twitter:site\" content=\"#{twitter}\"/>"
    end
  end

  def get_analytics() do
    code = Application.get_env(:ginjyo, :google_analytics)
    if String.length(code) > 0 do
      "<script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
        ga('create', '#{code}', 'auto');
        ga('send', 'pageview');
        </script>"
    end
  end
end

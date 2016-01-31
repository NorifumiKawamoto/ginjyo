defmodule Ginjyo.ArticleView do
  use Ginjyo.Web, :view
  import Scrivener.HTML

  def get_title(str) do
    str
    |> String.replace(~r/\r\n|\n|\r/, "")
    |> String.replace("/^　*(.*?)　*$/u", "")
    |> String.replace("*", "")
    |> String.replace("#", "")
  end

  def get_description(str) do
    str
    |> String.replace(~r/\r\n|\n|\r/, "")
    |> String.replace("/^　*(.*?)　*$/u", "")
    |> String.replace("*", "")
    |> String.replace("#", "")
  end

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end

end

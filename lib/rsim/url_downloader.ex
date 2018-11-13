defmodule Rsim.UrlDownloader do
  @moduledoc """
  Image manager.

  """

  @doc """
  Creates image from provided URL
  """
  def to_tmp_file(url) do
    %HTTPoison.Response{body: body, headers: headers} = HTTPoison.get!(url)
    size = fetch_header_value(headers, "Content-Length")

    tmp_path = build_tmp_path(url)
    File.write!(tmp_path, body)
    tmp_path
  end

  defp build_tmp_path(url) do
    uri = URI.parse(url)
    basename = Path.basename(uri.path)
    unique_dir = System.unique_integer([:positive]) |> Integer.to_string
    tmp_dir = Path.join(System.tmp_dir(), unique_dir)
    File.mkdir_p!(tmp_dir)
    "#{tmp_dir}/#{basename}"
  end

  defp fetch_header_value(headers, needed_header) do
    needed_header = String.downcase(needed_header)
    header = Enum.find(headers, fn(header) ->
      {header, _value} = header
      String.downcase(header) == needed_header
    end)
    if header do
      {_header, value} = header
      value
    else
      nil
    end
  end
end
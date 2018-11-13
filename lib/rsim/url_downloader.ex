defmodule Rsim.UrlDownloader do
  @moduledoc """
  Image manager.

  """

  @doc """
  Creates image from provided URL
  """
  def to_tmp_file(url) do
    save_tmp_file(url, HTTPoison.get(url))
  end

  defp save_tmp_file(url, {:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    tmp_path = build_tmp_path(url)
    File.write!(tmp_path, body)
    {:ok, tmp_path}
  end

  defp save_tmp_file(_, {:ok, %HTTPoison.Response{status_code: 404}}), do: {:error, :not_exists}
  defp save_tmp_file(_, {:error, %HTTPoison.Error{reason: reason}} ), do: {:error, reason}

  defp build_tmp_path(url) do
    uri = URI.parse(url)
    basename = Path.basename(uri.path)
    unique_dir = System.unique_integer([:positive]) |> Integer.to_string
    tmp_dir = Path.join(System.tmp_dir(), unique_dir)
    File.mkdir_p!(tmp_dir)
    "#{tmp_dir}/#{basename}"
  end
end
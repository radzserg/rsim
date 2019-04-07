defmodule Rsim.ImageDownloader do
  @moduledoc """
  Image Downloader, downloads image to tmp path
  """

  alias Rsim.PathBuilder

  @doc """
  Creates image from provided URL

      {:ok, tmp_path} = Rsim.ImageDownloader.to_tmp_file("http://example.com/image.png")

  """
  @spec to_tmp_file(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def to_tmp_file(url) do
    url = String.trim(url)

    if url == "" do
      {:error, :empty_url}
    else
      save_tmp_file(url, HTTPoison.get(url, [], follow_redirect: true ))
    end
  end

  defp save_tmp_file(_, {:ok, %HTTPoison.Response{status_code: 404}}), do: {:error, :not_exists}
  defp save_tmp_file(_, {:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}
  defp save_tmp_file(_, {:ok, %HTTPoison.Response{body: body}}) when body == "", do: {:error, :empty_file}
  defp save_tmp_file(url, {:ok, %HTTPoison.Response{body: body}}) do
    tmp_path = create_tmp_path(url)
    File.write!(tmp_path, body)
    {:ok, tmp_path}
  end

  defp create_tmp_path(url) do
    tmp_path = PathBuilder.tmp_path_from_url(url)

    tmp_path
    |> Path.dirname()
    |> File.mkdir_p!()

    tmp_path
  end
end

defmodule Rsim.PathBuilder do
  @moduledoc """
  Responsible for building paths
  """

  def key_from_url(url, prefix) do
    uri = URI.parse(url)
    basename = Path.basename(uri.path)
    hash = random_string(32)
    path = "#{prefix}/#{hash}/#{basename}"
    path
  end

  def tmp_path_from_url(url) do
    uri = URI.parse(url)
    basename = Path.basename(uri.path)
    unique_dir = random_string(32)
    dir = Path.join(System.tmp_dir(), unique_dir)
    "#{dir}/#{basename}"
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
defmodule Rsim.PathBuilder do
  @moduledoc """
  Responsible for building paths
  """

  @doc """
  Builds key for a storage from provided path.
  """
  @spec key_from_path(String.t(), String.t(), String.t()) :: String.t()
  def key_from_path(path, prefix, id) do
    uri = URI.parse(path)
    basename = Path.basename(uri.path)
    path = "#{prefix}/#{id}/#{basename}"
    path
  end

  @spec key_from_path(String.t(), String.t(), String.t(), String.t()) :: String.t()
  def key_from_path(path, prefix, id, parent_id) do
    uri = URI.parse(path)
    basename = Path.basename(uri.path)
    path = "#{prefix}/#{parent_id}/#{id}/#{basename}"
    path
  end

  @doc """
  Builds path to save file temporary
  """
  @spec tmp_path_from_url(String.t()) :: String.t()
  def tmp_path_from_url(url) do
    uri = URI.parse(url)
    basename = Path.basename(uri.path)
    unique_dir = random_string(32)
    dir = Path.join(System.tmp_dir(), unique_dir)
    "#{dir}/#{basename}"
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end

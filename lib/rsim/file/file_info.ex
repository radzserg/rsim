defmodule Rsim.FileInfo do
  @moduledoc """
  Helper to get basic file info
  """

  @doc """
  Defines mime type for a file
  """
  @spec get_mime!(String.t()) :: String.t()
  def get_mime!(path) do
    {result, 0} = System.cmd("file", ["--mime-type" | [path]])

    result
    |> String.split(":")
    |> List.last()
    |> String.trim()
    |> String.downcase()
  end

  @doc """
  Defines file size
  """
  @spec get_size!(String.t()) :: number
  def get_size!(path) do
    stat = File.stat!(path)
    stat.size
  end
end

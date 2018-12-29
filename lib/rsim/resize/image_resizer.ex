defmodule Rsim.ImageResizer do
  @moduledoc """
  Allows to resize image
  """

  @doc """
  Resize provided image to specified size, saves to dest path
  """
  @callback resize(
              src_path :: String.t(),
              dest_path :: String.t(),
              width :: number,
              height :: number
            ) :: :ok | {:error, String.t()}
end

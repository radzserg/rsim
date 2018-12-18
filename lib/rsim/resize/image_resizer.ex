defmodule Rsim.ImageResizer do
  @moduledoc """
  Allows to resize image
  """

  @doc """
  Resize provided image to specified size, saves to dest path
  """
  @callback resize(String.t(), String.t(), number, number) :: :ok | {:error, String.t()}
end

defmodule Rsim.ImageMeter do
  @moduledoc """
  Defines image size
  """

  @doc """
  Defines image size by provided file path
  """
  @callback size(String.t()) :: {:ok, number, number} | {:error, String.t()}
end

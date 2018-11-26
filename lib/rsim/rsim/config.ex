defmodule Rsim.Config do
  @moduledoc """
  Helper to get basic file info
  """

  def repo() do
    Application.get_env(:rsim, :repo)
  end

  def storage() do
    Application.get_env(:rsim, :storage)
  end

  def image_repo() do
    Application.get_env(:rsim, :image_repo)
  end

  def s3_config() do
    Application.get_env(:rsim, :s3)
  end
end
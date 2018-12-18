defmodule Rsim.Config do
  @moduledoc """
  Helper to get basic file info
  """

  @doc """
  Returns Rsim.Repo configured for rsim app
  """
  def repo() do
    Application.get_env(:rsim, :repo)
  end

  @doc """
  Returns Rsim.Storage configured for rsim app
  """
  def storage() do
    Application.get_env(:rsim, :storage, Rsim.S3Storage)
  end

  @doc """
  Returns Rsim.ImageRepo configured for rsim app
  """
  def image_repo() do
    Application.get_env(:rsim, :image_repo, Rsim.ImageEctoRepo)
  end

  @doc """
  Returns Rsim.ImageResizer configured for rsim app
  """
  def resizer() do
    Application.get_env(:rsim, :resizer, Rsim.ImageResizerMogrify)
  end

  @doc """
  Returns Rsim.ImageMeter configured for rsim app
  """
  def meter() do
    Application.get_env(:rsim, :image_meter, Rsim.ImageMeterMogrify)
  end
end

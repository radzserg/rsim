defmodule Rsim.Config do
  @moduledoc """
  Helper to get basic file info
  """

  def repo() do
    Application.get_env(:rsim, :repo)
  end

  def storage() do
    Application.get_env(:rsim, :storage, Rsim.S3Storage)
  end

  def image_repo() do
    Application.get_env(:rsim, :image_repo, Rsim.ImageEctoRepo)
  end

  def s3_config() do
    Application.get_env(:rsim, :s3)
  end

  def resizer() do
    Application.get_env(:rsim, :resizer, Rsim.ImageResizerMogrify)
  end

  def meter() do
    Application.get_env(:rsim, :image_meter, Rsim.ImageMeterMogrify)
  end
end

defmodule Rsim.Image do
  @enforce_keys [:id, :type, :path, :mime, :size, :width, :height]
  defstruct id: nil, type: nil, path: nil, mime: nil, size: nil, width: nil, height: nil

  @type t :: %Rsim.Image{
          id: String.t(),
          type: String.t(),
          path: String.t(),
          mime: String.t(),
          size: number
        }
end

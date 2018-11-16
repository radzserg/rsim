defmodule Rsim.Image do
  @enforce_keys [:id, :type, :path, :mime, :size]
  defstruct id: nil, type: nil, path: nil, mime: nil, size: nil

  @type t :: %Rsim.Image{id: String.t(), type: String.t(), path: String.t(), mime: String.t(), size: number}

end
defmodule Rsim.S3Storage do
  @moduledoc """
  S3 Uploader Behaviour
  """

  @behaviour Rsim.Storage

  alias ExAws.S3

  @impl Rsim.Storage
  def save_file(source_file, key, opts \\ %{}) do
    opts
      |> Map.put_new(:acl, :public_read)

    source_file = File.read!(source_file)

    s3_config = Rsim.Config.s3_config();
    case S3.put_object(s3_config[:bucket], key, source_file, opts) |> ExAws.request do
      {:ok, response} ->
        case response.status_code do
          200 -> :ok
          _ -> {:error, response.body}
        end
      {:error, error} -> {:error, error}
    end
  end
end
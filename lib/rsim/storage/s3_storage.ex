defmodule Rsim.S3Storage do
  @moduledoc """
  S3 Uploader Behaviour
  """

  @behaviour Rsim.Storage

  alias ExAws.S3

  @doc """
  Save file to storage
  """
  @callback save_file(String.t, String.t, Map) :: :ok | {:error, String.t}
  @impl Rsim.Storage
  def save_file(source_file, key, opts \\ %{}) do
    opts = opts
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

  @doc """
  Returns URL to the file in storage
  """
  @callback file_url(String.t) :: {:ok, String.t()} | {:error, String.t}
  @impl Rsim.Storage
  def file_url(key) do
    s3_config = Rsim.Config.s3_config();
    bucket = s3_config[:bucket]
    {:ok, "https://s3.amazonaws.com/#{bucket}/#{key}"}
  end


  @doc """
  Saves object to local file
  """
  def save_to_local_file!(key, local_path) do
    case S3.get_object(@config[:bucket], key) |> ExAws.request do
      {:ok, response} ->
        case response.status_code do
          200 ->
            File.write!(local_path, response.body)
          {:error, error} -> {:error, error}
        end
      {:error, error} ->
        # IO.inspect error
        {:error, error}
    end
  end
end
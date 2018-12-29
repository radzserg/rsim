defmodule Rsim.S3Storage do
  @moduledoc """
  S3 Uploader Behaviour
  """

  @behaviour Rsim.Storage

  alias ExAws.S3

  @doc """
  Save file to storage
  """
  @spec save(source_file :: String.t(), key :: String.t(), opts :: Map) ::
          :ok | {:error, String.t()}
  @impl Rsim.Storage
  def save(source_file, key, opts \\ %{}) do
    opts =
      opts
      |> Map.put_new(:acl, :public_read)

    source_file = File.read!(source_file)

    case S3.put_object(s3_bucket(), key, source_file, opts) |> ExAws.request() do
      {:ok, response} ->
        case response.status_code do
          200 -> :ok
          _ -> {:error, response.body}
        end

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Returns URL to the file in storage
  """
  @spec file_url(key :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @impl Rsim.Storage
  def file_url(key) do
    bucket = s3_bucket()
    {:ok, "https://s3.amazonaws.com/#{bucket}/#{key}"}
  end

  @doc """
  Delete files from storage
  """
  @impl Rsim.Storage
  @spec delete_all(keys :: [String.t()]) :: :ok | {:error, String.t()}
  def delete_all(keys) do
    S3.delete_all_objects(s3_bucket(), keys)
    :ok
  end

  defp s3_bucket() do
    Application.get_env(:rsim, :s3)[:bucket]
  end
end

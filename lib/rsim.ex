defmodule Rsim do
  @moduledoc """

  # Rsim

  Rsim - is image manager that allows to upload and fetch images easily. It is integrated with ecto and AWS S3.

  ```elixir

  # will upload image to s3, save to DB and provide image_id
  {:ok, image_id} = Rsim.save_image_from_file(path, :user)
  # will upload image to s3 from provided URL, save to DB and provide image_id
  {:ok, image_id} = Rsim.save_image_from_url(url, :user)

   # returns image src
  {:ok, image_src} = Rsim.get_image_url(image_id)
  # resize image on the fly, saves new resized image and returns image src
  {:ok, image_src} = Rsim.get_image_url(image_id, 200, 150)
  ```


  ## Installation

  Add `rsim` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
  [
    {:rsim, "~> 0.1.0"}
  ]
  end

  # add configuration
  # currently only AWS S3 storage is suppoted so make sure
  # you have config for :ex_aws as well

  config :ex_aws,
  access_key_id: "",
  secret_access_key: "",
  region: ""

  config :rsim,
  repo: MyApp.Repo,
  s3: [bucket: "bucket-name"]


  ```

  Copy and run migration to add `images` table from `priv/repo/migrations/`. Add `image_id` to your application
  tables that will have images.

  ```elixir
    def change do
      alter table(:users) do
        add(:image_id, references(:images, on_delete: :nothing, type: :binary_id))
      end

      create(index(:users, [:image_id]))
    end


    defmodule MyApp.Accounts.User do
      use Ecto.Schema
      schema "users" do
        # other fields
        belongs_to(:image, Rsim.EctoImage, type: :binary_id)
      end
    end
  ```


  ## Real world example

  ```elixir

  defmodule MyApp.Accounts.Registrator do

    def register_user(user_params) do
      user_params = if !Map.has_key?(user_params, :image_id) && Map.has_key?(user_params, :image_url) do
        Map.put(user_params, :image_id, save_image_from_url!(user_params.image_url))

      sign_up_changeset(%User{}, user_params)
        |> Repo.insert()
    end

    defp save_image_from_url!(url) when is_nil(url), do: nil
    defp save_image_from_url!(url) do
      # case Rsim.save_image_from_file(uploaded_file.path, :user) do
      case Rsim.save_image_from_url(url, :user) do
        {:ok, image} -> image.id
        {:error, error} -> nil
      end
    end
  end


  defmodule MyApp.Accounts.Avatar do
    alias MyApp.Accounts.User

    def fetch_avatar_url(user = %User{}) do
      fetch_image_url(user.image_id)
    end

    defp fetch_image_url(image_id) when is_nil(image_id), do: nil
    defp fetch_image_url(image_id) do
      # case Rsim.get_image_url(image_id) do          # get original image URL
      case Rsim.get_image_url(image_id, 150, 150) do  #  resize image on the fly and get image_url
        {:ok, image_url} -> image_url
        {:error, _} -> nil
      end
    end
  end
  ```

  ## How It Works

  ```
  __________
  |  images |
  |_________|
  |    id   |    - unique image id
  |   path  |    - path in storage
  |   mime  |    - image mime type
  |   size  |    - image file size
  |   width |    - image width
  |  height |    - image height
  |parent_id|    - reference for parent image (appears on resized images)
  |_________|
     |
     |___________
  __________      |
  |  users  |     |
  |_________|     |
  |    id   |     |
  |   etc   |     |
  | image_id| ----|
  |         |
  |_________|
  ```

  When you upload new image via `Rsim.save_image_from_file` or `Rsim.save_image_from_url` it will be uploaded to storage.
  (Currently only AWS s3 is supported). Then image info will be saved to `images` table, including path in storage and
  some metadata like image width/height, mime, file size. `images.id` will be returned - it's responsibility of your app
  to save it to application tables that have images.

  When you fetch image URL - storage will transform path to valid image source. You also can get resized image on the fly.
  In that case new resized image will be saves with reference `images.parent_id` to original image.



  """

  @doc """
  Saves image provided via URL, returns image_id
  {:ok, image_id} = Rsim.save_image_from_url("http://example.com/path/to/image.jpg", :user)

  `url` - is URL to the image
  `image_type` - identificator for image type. For `users` table it could be :user. We keep image type
    to easily relate images with different tables that have images
  `image_id` - UUID from `images.id`
  """
  @spec save_image_from_url(String.t(), atom()) :: {:ok, Rsim.Image.t()} | {:ok, :atom}
  defdelegate save_image_from_url(url, image_type), to: Rsim.StorageUploader

  @doc """
  Saves image from local path, returns image_id
  {:ok, image_id} = Rsim.save_image_from_url("/path/to/local/file", :user)

  `path` - is path to local file
  `image_type` - identificator for image type. For `users` table it could be :user. We keep image type
    to easily relate images with different tables that have images
  `image_id` - UUID from `images.id`
  """
  @spec save_image_from_file(String.t(), atom()) :: {:ok, Rsim.Image.t()} | {:ok, :atom}
  defdelegate save_image_from_file(file_path, image_type), to: Rsim.StorageUploader

  @doc """
  Returns image URL for image
  {:ok, image_src} = Rsim.get_image_url("2f8e8e23-ee58-47bb-9610-6881652a1f34")
  """
  @spec get_image_url(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  defdelegate get_image_url(image_id), to: Rsim.ImageFetcher, as: :get_image_url

  @doc """
  Returns image URL for image. Resize image if resized copy is missing.

  {:ok, image_src} = Rsim.get_image_url("2f8e8e23-ee58-47bb-9610-6881652a1f34", 200, 150)
  """
  @spec get_image_url(String.t(), number, number) :: {:ok, String.t()} | {:error, String.t()}
  defdelegate get_image_url(image_id, width, height), to: Rsim.ImageFetcher, as: :get_image_url
end

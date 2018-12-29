defmodule RsimTest.PathBuilderTest do
  use ExUnit.Case, async: true
  doctest Rsim.PathBuilder

  alias Rsim.PathBuilder

  test "it build tmp path" do
    path = PathBuilder.tmp_path_from_url("http://example.com/some/path/name.jpg")
    tmp_path = Path.dirname(System.tmp_dir() <> "/")
    r = ~r/#{tmp_path}\/\S{32}\/name\.jpg/
    assert Regex.match?(r, path)
  end

  test "it builds key for storage from url" do
    path = PathBuilder.key_from_path("http://example.com/some/path/name.jpg", "user", "unique_id")
    r = ~r/user\/unique_id\/name\.jpg/
    assert Regex.match?(r, path)
  end

  test "it builds key for storage from path" do
    path = PathBuilder.key_from_path("/some/path/name.jpg", "user", "unique_id")
    r = ~r/user\/unique_id\/name\.jpg/
    assert Regex.match?(r, path)
  end

  test "it builds key for resized image" do
    path =
      PathBuilder.key_from_path_with_parent(
        "/some/path/name.jpg",
        "user",
        "unique_id",
        "parent_id"
      )

    r = ~r/user\/parent_id\/unique_id\/name\.jpg/
    assert Regex.match?(r, path)
  end
end

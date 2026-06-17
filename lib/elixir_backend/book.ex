defmodule ElixirBackend.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :author]}
  schema "books" do
    field :title, :string
    field :author, :string

    timestamps()
  end

  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author])
    |> validate_required([:title, :author])
  end
end

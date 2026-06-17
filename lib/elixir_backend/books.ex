defmodule ElixirBackend.Books do
  alias ElixirBackend.{Repo, Book}

  def list_books do
    Repo.all(Book)
  end

  def get_book(id) do
    Repo.get(Book, id)
  end
end

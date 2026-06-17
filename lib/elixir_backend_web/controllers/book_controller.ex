defmodule ElixirBackendWeb.BookController do
  use ElixirBackendWeb, :controller

  alias ElixirBackend.Books

  def index(conn, _params) do
    json(conn, Books.list_books())
  end

  def show(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {int_id, ""} ->
        case Books.get_book(int_id) do
          nil -> conn |> put_status(:not_found) |> json(%{error: "Book not found"})
          book -> json(conn, book)
        end

      _ ->
        conn |> put_status(:bad_request) |> json(%{error: "Invalid ID"})
    end
  end
end

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias ElixirBackend.{Repo, Book}

# Clear existing books to keep seeds idempotent
Repo.delete_all(Book)

Repo.insert!(%Book{title: "Programming Elixir", author: "Dave Thomas"})
Repo.insert!(%Book{title: "Designing Elixir Systems with OTP", author: "John Hughes"})
Repo.insert!(%Book{title: "Phoenix in Action", author: "Geoffrey Lessel"})

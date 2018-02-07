defmodule HeaderTokenAuth do
  use Plug.Builder

  plug HeaderTokenAuth.TokenAuth
  plug HeaderTokenAuth.RequireCurrentUser

  def call(conn, opts) do
    conn
    |> HeaderTokenAuth.TokenAuth.call(opts)
    |> HeaderTokenAuth.RequireCurrentUser.call(opts)
  end
end

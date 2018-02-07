defmodule HeaderTokenAuth.RequireCurrentUser do
  def init(_options) do
  end

  def call(conn, _options) do
    if conn.assigns[:current_user] do
      conn
    else
      send_unauthorized(conn)
    end
  end

  # private

    defp send_unauthorized(conn) do
      conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> Plug.Conn.send_resp(401, "\"Unauthorized\"")
      |> Plug.Conn.halt
    end
end

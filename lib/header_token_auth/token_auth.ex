defmodule HeaderTokenAuth.TokenAuth do
  def init(options) do
    options
  end

  def call(conn, options) do
    finder = Keyword.fetch!(options, :finder)

    case Plug.Conn.get_req_header(conn, "authorization") do
      ["Token " <> token] -> find_user(conn, token, finder)
      _ -> conn
    end
  end

  # private

    defp find_user(conn, token, finder) do
      user = finder.(token)
      Plug.Conn.assign(conn, :current_user, user)
    end
end

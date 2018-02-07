require IEx
defmodule TokenAuthTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule User do
    def find_by_token(_conn, token) do
      if token == "token" do
        %{id: 1}
      else
        "not user"
      end
    end
  end

  alias TokenAuthTest.User

  describe "when token is not present" do
    test "it should set nil as current user" do
      conn = conn(:get, "/")
      conn = HeaderTokenAuth.TokenAuth.call(conn, finder: &User.find_by_token/2)

      assert conn.status != 401
      assert conn.halted() == false
      assert conn.assigns[:current_user] == nil
    end
  end

  describe "when token is present and correct" do
    test "it should set correct current_user" do
      conn = conn(:get, "/") |> Plug.Conn.put_req_header("authorization", "Token token")
      conn = HeaderTokenAuth.TokenAuth.call(conn, finder: &User.find_by_token/2)

      assert conn.status != 401
      assert conn.halted() == false
      assert conn.assigns[:current_user] == %{id: 1}
    end
  end

  describe "when token is present but incorrect" do
    test "it should set return value as current_user" do
      conn = conn(:get, "/") |> Plug.Conn.put_req_header("authorization", "Token incorrect")
      conn = HeaderTokenAuth.TokenAuth.call(conn, finder: &User.find_by_token/2)

      assert conn.status != 401
      assert conn.halted() == false
      assert conn.assigns[:current_user] == "not user"
    end
  end
end

defmodule HeaderTokenAuthTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule User do
    def find_by_token(_conn, token) do
      if token == "token" do
        %{id: 1}
      else
        nil
      end
    end

    def no_nil_return(_conn, _token) do
      "not nil"
    end
  end

  defmodule DemoPlug do
    use Plug.Builder

    plug HeaderTokenAuth

    plug :index
    defp index(conn, _opts), do: conn |> send_resp(200, "OK")
  end

  describe "when token is not present" do
    test "it should render unathorized" do
      conn = conn(:get, "/") |> HeaderTokenAuth.call(finder: &User.find_by_token/2)

      assert conn.status == 401
      assert conn.halted() == true
      assert conn.assigns == %{}
    end
  end

  describe "when token is present and correct" do
    test "it should set correct current_user" do
      conn = conn(:get, "/") |> Plug.Conn.put_req_header("authorization", "Token token")
      conn = HeaderTokenAuth.call(conn, finder: &User.find_by_token/2)

      assert conn.status != 401
      assert conn.halted() == false
      assert conn.assigns[:current_user] == %{id: 1}
    end
  end

  describe "when token is present but incorrect" do
    test "it should halt on falsey values" do
      conn = conn(:get, "/") |> Plug.Conn.put_req_header("authorization", "Token incorrect")
      conn = HeaderTokenAuth.call(conn, finder: &User.find_by_token/2)

      assert conn.status == 401
      assert conn.halted() == true
      assert conn.assigns == %{current_user: nil}
    end

    test "it should not halt on truthy values" do
      conn = conn(:get, "/") |> Plug.Conn.put_req_header("authorization", "Token incorrect")
      conn = HeaderTokenAuth.call(conn, finder: &User.no_nil_return/2)

      assert conn.status != 401
      assert conn.halted() == false
      assert conn.assigns == %{current_user: "not nil"}
    end
  end
end

defmodule RequireCurrentUserTest do
  use ExUnit.Case, async: true
  use Plug.Test

  describe "when user is not present" do
    test "it should send 401 status" do
      conn = conn(:get, "/")
      conn = HeaderTokenAuth.RequireCurrentUser.call(conn, %{})

      assert conn.status == 401
      assert conn.halted() == true
      assert conn.resp_body() == "\"Unauthorized\""
      assert get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]
    end
  end

  describe "when user is present" do
    test "it should send 200 status" do
      conn = conn(:get, "/") |> Plug.Conn.assign(:current_user, %{test: true})
      conn = HeaderTokenAuth.RequireCurrentUser.call(conn, %{})

      assert conn.status != 401
      assert conn.halted() == false
    end
  end
end

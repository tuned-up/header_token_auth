# Header Token Auth
  [![Hex.pm](https://img.shields.io/hexpm/v/header_token_auth.svg?style=flat-square)](https://hex.pm/packages/header_token_auth)
  [![Travis](https://img.shields.io/travis/tuned-up/header_token_auth.svg?style=flat-square)](https://travis-ci.org/tuned-up/header_token_auth)


  Dead simple token auth for phoenix\other plug-based frameworks.
  This plug consists of 2 other, very simple plugs: `HeaderTokenAuth.TokenAuth` (which loads user using supplied finder function) and `HeaderTokenAuth.RequireCurrentUser` (which halts the connection if no current_user is present).

## Usage
  Token should be set in `Authorization` header like so: `Token <actual token>`

  To use it, simply declare a plug in your `router.ex` file:
  ```elixir
    pipeline :api_auth do
      plug :accepts, ["json"]
      plug HeaderTokenAuth, finder: &MyApp.Users.find_by_auth_token/1
    end
  ```
  It is also possible to use plugs separately (e.g. if you want to set current user, but it's not required):
  ```elixir
    pipeline :api_auth do
      plug :accepts, ["json"]
      plug HeaderTokenAuth.TokenAuth, finder: &MyApp.Users.find_by_auth_token/1
    end
  ```
  or just require current_user if you don't trust me or already implemented some user loading(this plug is just few lines of code, so you'd better write it yourself)
  ```elixir
    pipeline :api_auth do
      plug :accepts, ["json"]
      plug HeaderTokenAuth.RequireCurrentUser
    end
  ```

## Requirements
  In order for this plug to work, you need to supply finder function. This function should be of arity 1 and will receive token from header. Anything that will be returned is set to `conn.assigns[:current_user]`. So don't return strings if user could not be found - second plug will halt connection only if `conn.assigns[:current_user]` is `false` or `nil`!
  As already mentioned,  token should be set in `Authorization` header like so: `Token <actual token>`.



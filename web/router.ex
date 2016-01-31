defmodule Ginjyo.Router do
  use Ginjyo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Ginjyo.Plugs.AllowAccess, [:all]
    plug Ginjyo.Locale
  end

  pipeline :admin do
  #  plug Ginjyo.Plugs.AllowAccess, [:internal]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", Ginjyo do
    pipe_through :browser # Use the default browser stack
    #pipe_through :admin # Limit IP
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
    resources "/users", UserController,  only: [:index, :new, :show, :update, :create, :edit]
    get "/users/:id/delete", UserController,  :delete
    get "/file", FileController, :index
    post "/file/upload", FileController, :file_upload
    resources "/roles", RoleController
    resources "/tags", TagController, only: [:index, :new, :show, :update, :create, :edit, :delete]
    resources "/articles", ArticleController, only: [:new, :create, :update, :edit, :delete]
  end

  scope "/", Ginjyo do
    pipe_through :browser # Use the default browser stack
    # public
    get "/", PageController, :index
    get "/tags/:id", ArticleController, :tagshow
    resources "/articles", ArticleController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Ginjyo do
  #   pipe_through :api
  # end
end

defmodule CompanyChallengeWeb.Router do
  use CompanyChallengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authentication do
    plug(CompanyChallengeWeb.Plugs.Authentication)
  end

  scope "/api", CompanyChallengeWeb do
    pipe_through :api

    resources("/signup", SignupController, only: [:create])

    resources("/auth", AuthenticationController, only: [:create])

    resources("/users", ClientsController, only: [:index])

    get("/user/:id/", ClientsController, :show)

    put("/user/:id", ClientsController, :update)

    get("/product/:id", ProductsController, :show)

    get("/user/products/:id", ProductsController, :get_by_client_id)
  end

  scope "/api", CompanyChallengeWeb do
    pipe_through [:api, :authentication]

    resources("/product", ProductsController, only: [:create])

    put("/product/:id", ProductsController, :update)

    resources("/products", ProductsController, only: [:index])
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CompanyChallengeWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

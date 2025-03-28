defmodule LiveviewWeb.Router do
  use LiveviewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveviewWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveviewWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/light", LightLive, metadata: %{tags: ["Form"]}
    live "/sandbox", SandboxLive, metadata: %{tags: ["Dynamic Form"]}
    live "/sales", SalesLive, metadata: %{tags: ["External Events"]}
    live "/bingo", BingoLive, metadata: %{tags: ["External Events"]}
    live "/flights", FlightsLive, metadata: %{tags: ["Search", "Autocomplete"]}
    live "/boats", BoatsLive, metadata: %{tags: ["Filtering", "Function Components"]}
    live "/servers", ServersLive, metadata: %{tags: ["Live Navigation"]}
    live "/donations", DonationsLive, metadata: %{tags: ["Sorting", "Pagination"]}

    live "/volunteers", VolunteersLive,
      metadata: %{tags: ["Forms", "Validations", "Streams", "Toggling State", "Live Components"]}
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveviewWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:liveview, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard",
        metrics: LiveviewWeb.Telemetry,
        ecto_repos: [Liveview.Repo]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

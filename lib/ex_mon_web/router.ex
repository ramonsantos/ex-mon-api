defmodule ExMonWeb.Router do
  use ExMonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExMonWeb do
    pipe_through :api

    post "/trainers", TrainersController, :create
    delete "/trainers/:id", TrainersController, :delete
    get "/trainers/:id", TrainersController, :show
    put "/trainers/:id", TrainersController, :update

    get "/pokemons/:name", PokemonsController, :show

    resources("/trainer_pokemons", TrainerPokemonsController,
      only: [:create, :show, :delete, :update]
    )
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
      live_dashboard "/dashboard", metrics: ExMonWeb.Telemetry
    end
  end
end

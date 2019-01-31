defmodule RealWorldWeb.Router do
  use RealWorldWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(ProperCase.Plug.SnakeCaseParams)

    plug(
      Guardian.Plug.Pipeline,
      error_handler: RealWorldWeb.SessionController,
      module: RealWorldWeb.Guardian
    )

    plug(Guardian.Plug.VerifyHeader, realm: "Token")
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  pipeline :start_trace do
    ## START TRACE
    plug(
      Spandex.Plug.StartTrace,
      tracer: RealWorld.Tracing,
      tracer_opts: [service: :phoenix, resource: :empex, name: "root_query"]
    )

    ## UPDATE TRACE
    plug(RealWorldWeb.DatadogTraceUpdatePlug)
  end

  scope "/" do
    pipe_through(:api)
    pipe_through(:start_trace)
    #    forward("/api", RealWorldWeb.DatadogTraceStartPlug, schema: RealWorldWeb.Schema)
    forward("/graphiql", RealWorldWeb.AbsintheWithDatadogPlug, schema: RealWorldWeb.Schema)

    get("/recipes/feed", RealWorldWeb.RecipeController, :feed)

    resources "/recipes", RealWorldWeb.RecipeController, except: [:new, :edit] do
      resources("/comments", RealWorldWeb.CommentController, except: [:new, :edit])
    end

    # to allow comments_path in test
    resources("/comments", RealWorldWeb.CommentController, except: [:new, :edit])
    get("/user", RealWorldWeb.UserController, :current_user)
    put("/user", RealWorldWeb.UserController, :update)
    post("/users", RealWorldWeb.UserController, :create)
    post("/users/login", RealWorldWeb.SessionController, :create)

    get("/profiles/:username", RealWorldWeb.ProfileController, :show)
    post("/profiles/:username/follow", RealWorldWeb.ProfileController, :follow)
    delete("/profiles/:username/follow", RealWorldWeb.ProfileController, :unfollow)

    ## Custom changes
    get("/recipes", RealWorldWeb.RecipeController, :index)
  end
end

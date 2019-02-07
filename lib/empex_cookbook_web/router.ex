defmodule EmpexCookbookWeb.Router do
  use EmpexCookbookWeb, :router

  pipeline :api do
    plug(EmpexCookbook.Metrics)
    plug(:accepts, ["json"])
    plug(ProperCase.Plug.SnakeCaseParams)

    plug(
      Guardian.Plug.Pipeline,
      error_handler: EmpexCookbookWeb.SessionController,
      module: EmpexCookbookWeb.Guardian
    )



    plug(Guardian.Plug.VerifyHeader, realm: "Token")
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  pipeline :start_trace do
    ## START TRACE
    plug(
      Spandex.Plug.StartTrace,
      tracer: EmpexCookbook.Tracing,
      tracer_opts: [service: :phoenix, resource: :empex, name: "root_query"]
    )

    ## UPDATE TRACE

    plug(EmpexCookbookWeb.DatadogTraceUpdatePlug)
  end

  scope "/" do
    pipe_through(:api)
    pipe_through(:start_trace)
    #    forward("/api", EmpexCookbookWeb.DatadogTraceStartPlug, schema: EmpexCookbookWeb.Schema)
    forward("/api", EmpexCookbookWeb.AbsintheWithDatadogPlugAPI, schema: EmpexCookbookWeb.Schema)
    forward("/graphiql", EmpexCookbookWeb.AbsintheWithDatadogPlug, schema: EmpexCookbookWeb.Schema)

    get("/recipes/feed", EmpexCookbookWeb.RecipeController, :feed)

    resources "/recipes", EmpexCookbookWeb.RecipeController, except: [:new, :edit] do
      resources("/comments", EmpexCookbookWeb.CommentController, except: [:new, :edit])
    end

    # to allow comments_path in test
    resources("/comments", EmpexCookbookWeb.CommentController, except: [:new, :edit])
    get("/user", EmpexCookbookWeb.UserController, :current_user)
    put("/user", EmpexCookbookWeb.UserController, :update)
    post("/users", EmpexCookbookWeb.UserController, :create)
    post("/users/login", EmpexCookbookWeb.SessionController, :create)

    get("/profiles/:username", EmpexCookbookWeb.ProfileController, :show)
    post("/profiles/:username/follow", EmpexCookbookWeb.ProfileController, :follow)
    delete("/profiles/:username/follow", EmpexCookbookWeb.ProfileController, :unfollow)

    ## Custom changes
    get("/recipes", EmpexCookbookWeb.RecipeController, :index)
  end
end

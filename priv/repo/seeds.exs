defmodule RealWorld.DatabaseSeeder do
  alias RealWorld.Repo
  alias RealWorld.Cookbook.NonVeganic
  alias RealWorld.Cookbook.Recipe
  alias RealWorld.Cookbook.Ingredient

  def insert_nonveganic(i) do
    Repo.insert!(%NonVeganic{
      name: i
    })
  end

  def insert_recipe() do
    Repo.insert!(%Recipe{
      title: "pasta al ragu",
      ingredients: [
        %RealWorld.Cookbook.Ingredient{
          name: "pasta"
        },
        %RealWorld.Cookbook.Ingredient{
          name: "onion"
        }
      ],
      body:
        "1. Boil the kettle. ...
               2. Meanwhile, heat a heavy based casserole dish (eg. ...
               3. Add the onion and cook with the mince for 10 minutes. ...
               4. Add the oregano and milk and season with salt and pepper. ...
               5. Meanwhile, peel the skins from the tomatoes. ...
               6. Bring a large pot of salted water to the boil and cook the pasta until al dente and drain."
    })
  end

  def clear do
    Repo.delete_all()
  end
end

nonveganics = [
  "egg",
  "meat",
  "beef",
  "lamb",
  "chicken",
  "milk",
  "cheese",
  "fish",
  "fish oil",
  "sausage",
  "honey",
  "pasta",
  "latose",
  "white cheese",
  "white bread",
  "tomato purée", "red wine", "beef stock", "worcestershire sauce",
  "red capsicum", "bulbs", "semi sundried tomatoes",  "small celeriac",
  "chives", "tub creme fraiche", "horseradish sauce", "litre vegetable stock"
]

Enum.reduce(1..2000, nonveganics, fn _, acc -> acc ++ nonveganics end)
|> Enum.each(fn i -> RealWorld.DatabaseSeeder.insert_nonveganic(i) end)



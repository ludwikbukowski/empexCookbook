# Empex Cookbook

This project was created for purpose of my [presentation Datadog and Elixir](https://www.youtube.com/watch?v=OVAe7vjlVVY&t=3s) for [EMPEX LA conference](http://empex.co/la)

I present how to integrate your Elixir application with [Datadog](https://www.datadoghq.com/)
The application is based on Phoenix, Ecto and Absinthe frameworks.

# Backend application
Setup Postgres in docker:
```
$ docker run --name empex -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
```
Setup ecto:
```
$ mix ecto.create
$ mix ecto.migrate
```
Run application:
```
$ mix deps.get
$ mix phx.server
```

# Frontend application
Run:
```
$ cd angular-front
$ npm install
$ ng serve
```
and navigate to http://localhost:4200/
Now you can create and remove recipes.

defmodule EmpexCookbook.Requester do
  use EmpexCookbook.Decorator
  @image_url "https://reqres.in/api/users?delay=2"

  def request_image(username) do
    res =
      username
      |> prepare_url()
      |> get_request()
      |> decode_body()

    {:ok, List.last(res["data"])["avatar"]}
  end

  #  @decorate tracer(:web)
  defp get_request(url) do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)
    body
  end

  defp prepare_url("ludwik") do
    "https://reqres.in/api/users?delay=2"
  end

  defp prepare_url(_) do
    "https://reqres.in/api/users?delay=0.05"
  end

  defp decode_body(body) do
    Poison.decode!(body)
  end
end

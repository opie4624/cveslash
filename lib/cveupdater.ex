
defmodule Cveupdater do
  def fetch_body(url) do
    :ssl.start
    :inets.start
    {:ok, {{_, 200, _}, _, body}} = :httpc.request(url)
		body
  end
end

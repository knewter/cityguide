defrecord City, name: "", woeid: ""

defmodule Cityguide.Guide do
  use Weber.Controller

  layout false
  def action([cityname: cityname], _conn) do
    city = city(cityname)
    temperature = fetch_temperature(city.woeid)
    {:render, [cityname: city.name, temperature: temperature], []}
  end

  defp fetch_temperature(woeid) do
    {_, seconds, _} = :erlang.now
    SimpleCache.fetch woeid, seconds, fn ->
      CurrentWeather.YahooFetcher.fetch(woeid)
    end
  end

  defp city(cityname) when is_binary(cityname) do
    city(binary_to_existing_atom(cityname))
  end
  defp city(cityname) when is_atom(cityname) do
    cities[cityname]
  end

  defp cities do
    [
      birmingham: City[name: "Birmingham, AL", woeid: "2364559"],
      atlanta:    City[name: "Atlanta, GA",    woeid: "2357024"]
    ]
  end
end

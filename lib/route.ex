defmodule Route do
  import Weber.Route
  require Weber.Route

  route on("GET", "/", :Cityguide.Main, :action)
     |> on("GET", "/cities/:cityname", :Cityguide.Guide, :action)
end

defmodule SimpleCacheTest do
  use ExUnit.Case

  setup do
    SimpleCache.start
    SimpleCache.configure cache_interval: 5 * 60 # five minute cache
    SimpleCache.clear
    :ok
  end

  test "configuring cache_interval" do
    assert SimpleCache.get_configuration[:cache_interval] == 5 * 60
    SimpleCache.configure cache_interval: 20
    assert SimpleCache.get_configuration[:cache_interval] == 20
  end

  test "uncached values execute the underlying function" do
    seconds = 0
    output = SimpleCache.fetch :foo, seconds, fn -> 1 end
    assert output == 1
  end

  test "cached values do not execute the underlying function" do
    seconds = 0
    SimpleCache.fetch :foo, seconds, fn -> 1 end
    output = SimpleCache.fetch :foo, seconds, fn -> 2 end
    assert output == 1
  end

  test "cached values execute the underlying function if the cache is stale" do
    seconds = 0
    SimpleCache.fetch :foo, seconds, fn -> 1 end
    stale_seconds = seconds + (5 * 60) + 1
    output = SimpleCache.fetch :foo, stale_seconds, fn -> 2 end
    assert output == 2
  end
end

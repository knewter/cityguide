defrecord SimpleCacheState,
            cache_interval: 60,
            cache: HashDict.new,
            cache_timings: HashDict.new

defmodule SimpleCache do
  use ExActor, export: :simple_cache, initial_state: SimpleCacheState.new

  defcast configure(new_config), state: state do
    state = state.cache_interval(new_config[:cache_interval])
    new_state(state)
  end

  defcast clear, state: state do
    state = state.cache(HashDict.new)
    state = state.cache_timings(HashDict.new)
    new_state(state)
  end

  defcall get_configuration, state: state do
    [
      cache_interval: state.cache_interval
    ]
  end

  defcall fetch(key, current_time, calculation), state: state do
    case has_non_stale_value?(state, key, current_time) do
      true ->
        state.cache[key]
      false ->
        new_value = calculation.()
        cache = Dict.put(state.cache, key, new_value)
        timings = Dict.put(state.cache_timings, key, current_time)
        state = state.cache(cache)
        state = state.cache_timings(timings)
        set_and_reply(state, new_value)
    end
  end

  defp has_non_stale_value?(state, key, current_time) do
    case Dict.has_key?(state.cache, key) do
      true ->
        cache_timing = state.cache_timings[key]
        current_time - state.cache_interval < cache_timing
      false ->
        false
    end
  end
end

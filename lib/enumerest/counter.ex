defmodule Enumerest.Counter do
  use GenServer

  def start_link(_args) do
    case GenServer.start_link(__MODULE__, %{}, [name: {:global, "counter"}]) do
      {:error, {:already_started, pid}} -> {:ok, pid}
      {:ok, pid}                        -> {:ok, pid}
    end
  end

  def count(id) do
    GenServer.call({:global, "counter"}, {:increment, id})
  end

  def summary do
    GenServer.call({:global, "counter"}, {:summary})
  end

  def reset do
    GenServer.call({:global, "counter"}, {:reset})
  end

  def handle_call({:increment, id}, _from, state) do
    {_, new_state} = Map.get_and_update(state, id, fn value -> {value, (value || 0) + 1} end)

    {:reply, new_state[id], new_state}
  end

  def handle_call({:summary}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:reset}, _from, state) do
    {:reply, state, %{}}
  end
end

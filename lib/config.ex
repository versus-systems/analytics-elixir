defmodule Segment.Config do
  use GenServer

  def start_link(write_key) do
    GenServer.start_link(__MODULE__, write_key, name: __MODULE__)
  end

  def init(write_key) do
    {:ok, write_key}
  end

  def write_key do
    GenServer.call(__MODULE__, :write_key)
  end

  def handle_call(:write_key, _from, state) do
    {:reply, state, state}
  end
end

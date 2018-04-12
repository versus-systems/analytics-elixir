defmodule Segment.Server do
  use GenServer

  alias Segment.Analytics.Http

  # 3 seconds
  @interval 3_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    schedule_flush()
    {:ok, %{events: [], flushed_at: nil}}
  end

  def add(event) do
    GenServer.cast(__MODULE__, {:add, event})
  end

  def batch_send_to_segment([]), do: nil

  def batch_send_to_segment(events) do
    Http.post_to_segment("batch", Poison.encode!(%{batch: events}))
  end

  def send_to_segment(event) do
    Http.post_to_segment(event.type, Poison.encode!(event))
  end

  def handle_cast({:add, event}, state) do
    events = [event | state.events]
    {:noreply, %{state | events: events}}
  end

  def handle_info(:flush_events, state) do
    Task.start(fn -> batch_send_to_segment(state.events) end)
    schedule_flush()
    {:noreply, %{events: [], flushed_at: DateTime.utc_now()}}
  end

  def schedule_flush do
    Process.send_after(self(), :flush_events, @interval)
  end
end

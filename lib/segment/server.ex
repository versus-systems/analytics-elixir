defmodule Segment.Store do
  use GenServer

  # 3 seconds
  @interval 3_000

  @stub_segment_calls %{true: Segment.Analytics.Noop, false: Segment.Analytics.Http}
  @segment Map.get(@stub_segment_calls, Application.get_env(:segment, :stub, false))

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
    @segment.post_to_segment("batch", Poison.encode!(%{batch: events}))
  end

  def send_to_segment(event) do
    @segment.post_to_segment(event.type, Poison.encode!(event))
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

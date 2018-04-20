defmodule Segment.Store do
  use GenServer

  # 3 seconds
  @interval 3_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    schedule_flush()
    client =
      Application.get_env(:segment, :stub)
      |> case do
        true -> Segment.Analytics.Noop
        _ -> Segment.Analytics.Http
      end
    {:ok, %{events: [], flushed_at: nil, client: client}}
  end

  ## CLIENT
  def add(event) do
    GenServer.cast(__MODULE__, {:add, event})
  end

  def send_to_segment([], _client), do: nil

  def send_to_segment(events, client) when is_list(events) do
    events
    |> Enum.group_by(& &1.write_key)
    |> Enum.each(& send_batch_async(&1, client))
  end

  def send_to_segment(event, client) do
    client.post_to_segment(event.type, Poison.encode!(event), event.write_key)
  end

  ## SERVER
  def handle_cast({:add, event}, state) do
    events = [event | state.events]
    {:noreply, %{state | events: events}}
  end

  def handle_info(:flush_events, state) do
    Task.start(fn -> send_to_segment(state.events, state.client) end)
    schedule_flush()
    {:noreply, %{state | events: [], flushed_at: DateTime.utc_now()}}
  end

  ## PRIVATE
  defp schedule_flush do
    Process.send_after(self(), :flush_events, @interval)
  end

  defp send_batch_to_segment(events, client) do
    write_key =
      events
      |> List.first()
      |> Map.get(:write_key)

    client.post_to_segment("batch", Poison.encode!(%{batch: events}), write_key)
  end

  defp send_batch_async({_write_key, events}, client) do
    Task.start(fn -> send_batch_to_segment(events, client) end)
  end
end

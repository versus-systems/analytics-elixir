defmodule Segment.Analytics do
  alias Segment.Analytics.Context

  def track(t = %Segment.Analytics.Track{}) do
    call(t)
  end

  def track(write_key, user_id, event, properties \\ %{}, context \\ Context.new()) do
    %Segment.Analytics.Track{
      write_key: write_key,
      userId: user_id,
      event: event,
      properties: properties,
      context: context
    }
    |> call
  end

  def identify(i = %Segment.Analytics.Identify{}) do
    call(i)
  end

  def identify(write_key, user_id, traits \\ %{}, context \\ Context.new()) do
    %Segment.Analytics.Identify{
      write_key: write_key,
      userId: user_id,
      traits: traits,
      context: context
    }
    |> call
  end

  def screen(s = %Segment.Analytics.Screen{}) do
    call(s)
  end

  def screen(write_key, user_id, name \\ "", properties \\ %{}, context \\ Context.new()) do
    %Segment.Analytics.Screen{
      write_key: write_key,
      userId: user_id,
      name: name,
      properties: properties,
      context: context
    }
    |> call
  end

  def alias(a = %Segment.Analytics.Alias{}) do
    call(a)
  end

  def alias(write_key, user_id, previous_id, context \\ Context.new()) do
    %Segment.Analytics.Alias{
      write_key: write_key,
      userId: user_id,
      previousId: previous_id,
      context: context
    }
    |> call
  end

  def group(g = %Segment.Analytics.Group{}) do
    call(g)
  end

  def group(write_key, user_id, group_id, traits \\ %{}, context \\ Context.new()) do
    %Segment.Analytics.Group{
      write_key: write_key,
      userId: user_id,
      groupId: group_id,
      traits: traits,
      context: context
    }
    |> call
  end

  def page(p = %Segment.Analytics.Page{}) do
    call(p)
  end

  def page(write_key, user_id, name \\ "", properties \\ %{}, context \\ Context.new()) do
    %Segment.Analytics.Page{
      write_key: write_key,
      userId: user_id,
      name: name,
      properties: properties,
      context: context
    }
    |> call
  end

  defp call(api) do
    Segment.Store.add(api)
  end
end

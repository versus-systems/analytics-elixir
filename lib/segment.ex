defmodule Segment do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      {Segment.Config, [Application.get_env(:segment, :write_key)]},
      {Segment.Server, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end

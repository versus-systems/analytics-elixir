defmodule Segment.Analytics.Noop do
  require Logger

  def post_to_segment(function, body) do
    Logger.debug("STUBBED Segment #{function} call with body #{body}")
  end
end

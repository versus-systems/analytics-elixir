defmodule Segment.Analytics.Http do
  use HTTPoison.Base

  require Logger

  @base_url "https://api.segment.io/v1/"

  def post_to_segment(function, body, write_key) do
    post(function, body, write_key)
    |> log_result(function, body)
  end

  def post(url, body, write_key, headers, options \\ []) do
    options_with_auth = Keyword.merge(options, hackney: [basic_auth: {write_key, ""}])

    request(:post, url, body, headers, options_with_auth)
  end

  def process_url(url) do
    @base_url <> url
  end

  def process_request_headers(headers) do
    headers
    |> Keyword.put(:"Content-Type", "application/json")
    |> Keyword.put(:accept, "application/json")
  end

  defp log_result({_, %{status_code: code}}, function, body) when code in 200..299 do
    # success
    Logger.debug("Segment #{function} call success: #{code} with body: #{body}")
  end

  defp log_result({_, %{status_code: code}}, function, body) do
    # HTTP failure
    Logger.debug("Segment #{function} call failed: #{code} with body: #{body}")
  end

  defp log_result(error, function, body) do
    # every other failure
    Logger.debug("Segment #{function} call failed: #{inspect(error)} with body: #{body}")
  end
end

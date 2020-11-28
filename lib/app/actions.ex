defmodule App.Actions do
  @moduledoc false

  require Logger

  def search(id, q) do
    query = q
            |> String.split(",")
            |> List.first
            |> String.trim
            |> String.capitalize

    State.update_name(id, query)

    url = "http://spiski.live/api?q=#{query}"

    results = case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} -> Poison.decode!(body)
      {:ok, %{status_code: 404}} -> Logger.error("404 for #{url}"); %{"#{query}" => []}
      {:error, %{reason: reason}} -> Logger.error("Error for #{url}: #{reason}"); %{"#{query}" => []}
      _ -> Logger.error("Other error for #{url}"); %{"#{query}" => []}
    end

    new_state = State.update_results(id, results[query])

    Logger.warn "New state:"
    new_state
    |> Logger.warn

    State.set(id, new_state)
    new_state
    |> IO.inspect

    markup(id, results[query])
  end

  def wanna_add_new_fields() do

  end

  def wanna_add_person() do

  end

  defp markup(id, []) do
    State.update_stage(id, "not_found")
    {"Информации о задержании такого человека нет. Если вы уверены, что это не так, напишите нам об этом", []}
  end

  defp markup(id, results) do
    State.update_stage(id, "not_found")
    {"Информации о задержании такого человека нет. Если вы уверены, что это не так, напишите нам об этом", []}
  end
end

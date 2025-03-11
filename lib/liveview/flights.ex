defmodule Liveview.Flights do
  def search_by_airport(airport) do
    Process.sleep(1000)

    airport = airport |> String.upcase() |> String.trim()

    case airport do
      "" ->
        []

      _ ->
        list_flights()
        |> Enum.filter(&(&1.origin == airport || &1.destination == airport))
    end
  end

  def suggest_airport(prefix) do
    prefix = String.upcase(prefix)

    list_flights()
    |> Enum.flat_map(fn flight -> [flight.origin, flight.destination] end)
    |> Enum.uniq()
    |> Enum.filter(&String.starts_with?(&1, prefix))
  end

  def list_flights do
    [
      %{
        number: "450",
        origin: "DEN",
        destination: "ORD",
        departure_time: time_from_now(days: 1, hours: 1),
        arrival_time: time_from_now(days: 1, hours: 3)
      },
      %{
        number: "450",
        origin: "DEN",
        destination: "ORD",
        departure_time: time_from_now(days: 2, hours: 2),
        arrival_time: time_from_now(days: 2, hours: 4)
      },
      %{
        number: "450",
        origin: "DEN",
        destination: "ORD",
        departure_time: time_from_now(days: 3, hours: 1),
        arrival_time: time_from_now(days: 3, hours: 3)
      },
      %{
        number: "450",
        origin: "DEN",
        destination: "ORD",
        departure_time: time_from_now(days: 4, hours: 2),
        arrival_time: time_from_now(days: 4, hours: 4)
      },
      %{
        number: "860",
        origin: "DFW",
        destination: "ORD",
        departure_time: time_from_now(days: 1, hours: 1),
        arrival_time: time_from_now(days: 1, hours: 3)
      },
      %{
        number: "860",
        origin: "DFW",
        destination: "ORD",
        departure_time: time_from_now(days: 2, hours: 2),
        arrival_time: time_from_now(days: 2, hours: 4)
      },
      %{
        number: "860",
        origin: "DFW",
        destination: "ORD",
        departure_time: time_from_now(days: 3, hours: 1),
        arrival_time: time_from_now(days: 3, hours: 3)
      },
      %{
        number: "740",
        origin: "DAB",
        destination: "DEN",
        departure_time: time_from_now(days: 1, hours: 2),
        arrival_time: time_from_now(days: 1, hours: 5)
      },
      %{
        number: "740",
        origin: "DAB",
        destination: "DEN",
        departure_time: time_from_now(days: 2, hours: 1),
        arrival_time: time_from_now(days: 2, hours: 4)
      },
      %{
        number: "740",
        origin: "DAB",
        destination: "DEN",
        departure_time: time_from_now(days: 3, hours: 2),
        arrival_time: time_from_now(days: 3, hours: 5)
      },
      %{
        number: "175",
        origin: "SFO",
        destination: "JFK",
        departure_time: time_from_now(days: 1, hours: 6),
        arrival_time: time_from_now(days: 1, hours: 14)
      },
      %{
        number: "622",
        origin: "SEA",
        destination: "MIA",
        departure_time: time_from_now(days: 2, hours: 8),
        arrival_time: time_from_now(days: 2, hours: 16)
      },
      %{
        number: "309",
        origin: "AUS",
        destination: "BOS",
        departure_time: time_from_now(days: 1, hours: 10),
        arrival_time: time_from_now(days: 1, hours: 14)
      },
      %{
        number: "841",
        origin: "PDX",
        destination: "ATL",
        departure_time: time_from_now(days: 3, hours: 7),
        arrival_time: time_from_now(days: 3, hours: 13)
      },
      %{
        number: "517",
        origin: "LAS",
        destination: "MSP",
        departure_time: time_from_now(days: 2, hours: 5),
        arrival_time: time_from_now(days: 2, hours: 9)
      },
      %{
        number: "936",
        origin: "HNL",
        destination: "LAX",
        departure_time: time_from_now(days: 1, hours: 9),
        arrival_time: time_from_now(days: 1, hours: 17)
      },
      %{
        number: "275",
        origin: "MCO",
        destination: "SLC",
        departure_time: time_from_now(days: 4, hours: 11),
        arrival_time: time_from_now(days: 4, hours: 15)
      },
      %{
        number: "753",
        origin: "PHL",
        destination: "SAN",
        departure_time: time_from_now(days: 2, hours: 14),
        arrival_time: time_from_now(days: 2, hours: 20)
      },
      %{
        number: "408",
        origin: "DTW",
        destination: "PHX",
        departure_time: time_from_now(days: 3, hours: 6),
        arrival_time: time_from_now(days: 3, hours: 9)
      }
    ]
  end

  defp time_from_now(options) do
    days = Keyword.get(options, :days, 0)
    hours = Keyword.get(options, :hours, 0)

    DateTime.utc_now()
    |> DateTime.add(days * 24 * 60 * 60 + hours * 60 * 60, :second)
    |> Calendar.strftime("%b %d at %H:%M")
  end
end

defmodule Liveview.VolunteersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Liveview.Volunteers` context.
  """

  @doc """
  Generate a volunteer.
  """
  def volunteer_fixture(attrs \\ %{}) do
    {:ok, volunteer} =
      attrs
      |> Enum.into(%{
        checked_out: true,
        name: "some name",
        phone: "(892) 349 8790"
      })
      |> Liveview.Volunteers.create_volunteer()

    volunteer
  end
end

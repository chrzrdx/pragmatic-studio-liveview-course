defmodule Liveview.DonationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Liveview.Donations` context.
  """

  @doc """
  Generate a donation.
  """
  def donation_fixture(attrs \\ %{}) do
    {:ok, donation} =
      attrs
      |> Enum.into(%{
        days_until_expires: 42,
        emoji: "some emoji",
        name: "some name",
        quantity: 42
      })
      |> Liveview.Donations.create_donation()

    donation
  end
end

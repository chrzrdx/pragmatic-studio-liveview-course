defmodule Liveview.Boats do
  @moduledoc """
  The Boats context.
  """

  import Ecto.Query, warn: false
  alias Liveview.Repo

  alias Liveview.Boats.Boat

  @doc """
  Returns the list of boats.

  ## Examples

      iex> list_boats()
      [%Boat{}, ...]

  """
  def list_boats do
    list_boats(%{prices: [], tags: []})
  end

  def list_boats(%{prices: prices, tags: tags}) when is_list(prices) and is_list(tags) do
    Boat
    |> filter_by_price(prices)
    |> filter_by_tag(tags)
    |> order_by(:price)
    |> select([:id, :name, :price, :image, :tags])
    |> Repo.all()
  end

  def list_tags do
    Repo.all(from boat in Boat, select: fragment("DISTINCT unnest(?)", boat.tags)) |> Enum.sort()
  end

  def list_prices do
    Repo.all(from boat in Boat, distinct: true, select: boat.price)
    |> Enum.sort_by(&String.length/1)
  end

  def filter_by_price(query, prices) when is_list(prices) and length(prices) > 0 do
    from boat in query, where: boat.price in ^prices
  end

  def filter_by_price(query, _), do: query

  def filter_by_tag(query, tags) when is_list(tags) and length(tags) > 0 do
    from boat in query, where: fragment("? && ?", boat.tags, ^tags)
  end

  def filter_by_tag(query, _), do: query

  @doc """
  Gets a single boat.

  Raises `Ecto.NoResultsError` if the Boat does not exist.

  ## Examples

      iex> get_boat!(123)
      %Boat{}

      iex> get_boat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_boat!(id), do: Repo.get!(Boat, id)

  @doc """
  Creates a boat.

  ## Examples

      iex> create_boat(%{field: value})
      {:ok, %Boat{}}

      iex> create_boat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_boat(attrs \\ %{}) do
    %Boat{}
    |> Boat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a boat.

  ## Examples

      iex> update_boat(boat, %{field: new_value})
      {:ok, %Boat{}}

      iex> update_boat(boat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_boat(%Boat{} = boat, attrs) do
    boat
    |> Boat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a boat.

  ## Examples

      iex> delete_boat(boat)
      {:ok, %Boat{}}

      iex> delete_boat(boat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_boat(%Boat{} = boat) do
    Repo.delete(boat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking boat changes.

  ## Examples

      iex> change_boat(boat)
      %Ecto.Changeset{data: %Boat{}}

  """
  def change_boat(%Boat{} = boat, attrs \\ %{}) do
    Boat.changeset(boat, attrs)
  end
end

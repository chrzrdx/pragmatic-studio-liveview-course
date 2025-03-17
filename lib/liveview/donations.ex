defmodule Liveview.Donations do
  @moduledoc """
  The Donations context.
  """
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Liveview.Repo

  alias Liveview.Donations.Donation

  defmodule ListParams do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field :sort_by, :string, default: "id"
      field :sort_direction, :string, default: "asc"
      field :page, :integer, default: 1
      field :per_page, :integer, default: 10
    end

    def changeset(params) do
      %__MODULE__{}
      |> cast(params, [:sort_by, :sort_direction, :page, :per_page])
      |> validate_inclusion(:sort_by, ~w(id name quantity days_until_expires))
      |> validate_inclusion(:sort_direction, ~w(asc desc))
      |> validate_number(:page, greater_than: 0)
      |> validate_inclusion(:per_page, [5, 10, 20, 50, 100])
    end

    def validate(params) do
      case apply_action(changeset(params), :validate) do
        {:ok, params} ->
          params |> Map.from_struct()

        {:error, _changeset} ->
          %ListParams{} |> Map.from_struct()
      end
    end
  end

  @doc """
  Returns the list of donations.

  ## Examples

      iex> list_donations()
      [%Donation{}, ...]

  """
  def list_donations(params \\ %{}) when is_map(params) do
    params = ListParams.validate(params)

    Donation
    |> sort(params)
    |> paginate(params)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_direction: sort_direction}) do
    sort_direction = String.to_atom(sort_direction)
    sort_by = String.to_atom(sort_by)

    query
    |> order_by([{^sort_direction, ^sort_by}, asc: :id])
  end

  defp paginate(query, %{page: page, per_page: per_page}) do
    query
    |> limit(^per_page)
    |> offset(^((page - 1) * per_page))
  end

  def count_donations, do: Repo.aggregate(Donation, :count)

  @doc """
  Gets a single donation.

  Raises `Ecto.NoResultsError` if the Donation does not exist.

  ## Examples

      iex> get_donation!(123)
      %Donation{}

      iex> get_donation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_donation!(id), do: Repo.get!(Donation, id)

  @doc """
  Creates a donation.

  ## Examples

      iex> create_donation(%{field: value})
      {:ok, %Donation{}}

      iex> create_donation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_donation(attrs \\ %{}) do
    %Donation{}
    |> Donation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a donation.

  ## Examples

      iex> update_donation(donation, %{field: new_value})
      {:ok, %Donation{}}

      iex> update_donation(donation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_donation(%Donation{} = donation, attrs) do
    donation
    |> Donation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a donation.

  ## Examples

      iex> delete_donation(donation)
      {:ok, %Donation{}}

      iex> delete_donation(donation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_donation(%Donation{} = donation) do
    Repo.delete(donation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking donation changes.

  ## Examples

      iex> change_donation(donation)
      %Ecto.Changeset{data: %Donation{}}

  """
  def change_donation(%Donation{} = donation, attrs \\ %{}) do
    Donation.changeset(donation, attrs)
  end
end

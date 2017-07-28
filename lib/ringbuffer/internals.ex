defmodule RingBuffer.Internals do
  @moduledoc false

  require Logger

  @opaque t :: %__MODULE__{
    size: non_neg_integer,
    head: number,
    tail: number,
    buffer: binary
  }

  defstruct size: 0, head: 0, tail: 0, default: :undefined, buffer: nil

  @app     Mix.Project.config[:app]
  @on_load :init
  @compile {:autoload, false}

  @doc false
  # Load NIF with fallback
  def init do
    unless Application.get_env(@app, :disable_nif, false) do
      so_path = Path.join(:code.priv_dir(@app), "ringbuffer")
      case :erlang.load_nif(so_path, 0) do
        :ok -> :ok
        {:error, {_reason, msg}} ->
          Logger.warn("Unable to load native interface, falling back to pure Elixir implementation: #{to_string(msg)}")
          :ok
      end
    end
    :ok
  end

  @spec nif_loaded? :: true | false
  def nif_loaded?, do: false

  @spec new(pos_integer, [atom: any]) :: t
  @doc "Create a new circular buffer with a fixed size"
  def new(capacity, default) do
    %__MODULE__{size: capacity, buffer: :array.new(capacity), default: default}
  end

  @spec get(t, non_neg_integer) :: any()
  @doc "Return the value at the specified index"
  def get(%{buffer: b}, index) do
    :array.get(index, b)
  end

  @spec set(t, non_neg_integer, any) :: t
  @doc "Store a value at the specified index"
  def set(%{buffer: b} = rb, index, value) do
    %{rb | buffer: :array.set(index, value, b)}
  end

  @spec reset(t, non_neg_integer) :: t
  @doc "Reset the value at the specified index to the default value"
  def reset(%{buffer: b} = rb, index) do
    %{rb | buffer: :array.reset(index, b)}
  end

  @spec clear(t) :: t
  @doc "Clear the whole buffer"
  def clear(%{size: s} = rb) do
    %{rb | buffer: :array.new(s), head: 0, tail: 0}
  end

  @spec to_list(t) :: [any]
  def to_list(%{buffer: b}) do
    :array.to_list(b)
  end

  @spec from_list([any], any) :: t
  def from_list(lst, default) do
    %__MODULE__{size: length(lst), buffer: :array.from_list(lst, default), default: default}
  end

end

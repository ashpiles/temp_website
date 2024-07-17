defmodule SVG do
  use GenServer
  alias SVG.Path, as: Path

  # =================================
  #             API
  # =================================

  # ------------
  # To Do
  # ------------
  # -[] set up sigil_SVG string parsing
  # -[] create user input filtering

  # for direct string parsing
  @spec sigil_SVG(String.t(), charlist()) :: Path.path() | String.t()
  defmacro sigil_SVG(path, opts) do
    quote do
      # Path.make_path(unquote(path), unquote(opts))
    end
  end

  # more obvious use
  @spec svg(Path.path() | String.t(), [atom()]) :: Path.path() | String.t()
  defmacro svg(path, opts \\ []) do
    quote do
      Path.make_path(unquote(path), unquote(opts))
    end
  end

  # =================================
  #           Client API
  # =================================

  # ------------
  # To Do
  # ------------
  # -[] intialization
  # -[] passing self to composer
  # -[] id options

  def add_svg(path) when is_binary(path) do
    GenServer.start_link(Path, path)
  end

  def push(pid, path) do
    GenServer.cast(pid, {:push, path})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  # =================================
  #           Server API
  # =================================

  @impl true
  def init(path) do
    svg = Path.make_svg(path)
    {:ok, svg}
  end

  @impl true
  def handle_call(:pop, _from, svg) do
    {:reply, svg}
  end
end

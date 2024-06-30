defmodule SVG.Path do
  use GenServer
  defstruct path: "", segments: []

  import SVG
  # okay so instead of a struct we use a gen server
  # and I can possibly wrap up the internal function opperations into sigils
  # the indvidual segments can be structs which are traversed and edited via it's
  # parent gen server
  # and a supervisor

  # =================================
  #        Internal Functions
  # =================================

  # Intialize #
  defp segs_to_svg(segments) do
    [path: "", segments: segments]
  end

  defp path_to_seg(path) do
    path
    |> String.to_charlist()
    |> glob_path(0)
    |> List.flatten()
  end

  defp ascii_to_str(a) do
    case a do
      [] -> ""
      _ -> List.to_string([a])
    end
  end

  defp glob_path([], _), do: %{}

  defp glob_path([h | t], index) when h in ~c"MLHVCSQTAZ" do
    {numbers, rest} = grab_numbers(t)
    key = ascii_to_str(h)

    seg = [
      %Seg{
        type: key,
        points:
          numbers
          |> String.split()
          |> Enum.map(&String.to_integer/1),
        index: index,
        path: key <> numbers
      }
    ]

    case rest do
      [] ->
        seg

      _ ->
        [seg | glob_path(rest, index + 1)]
    end
  end

  defp glob_path([_ | t], index), do: glob_path(t, index)

  defp grab_numbers([h | t]) when h in ~c"0123456789 -" do
    {numbers, rest} = grab_numbers(t)
    {ascii_to_str(h) <> numbers, rest}
  end

  defp grab_numbers(path = [h | _t]) when h in ~c"MLHVCSQTAZ", do: {"", path}
  defp grab_numbers([]), do: {"", []}
  defp grab_numbers([_h | t]), do: grab_numbers(t)

  # Ordering by Index #
  defp order_segs(svg) do
    split_segs(svg.)
  end

  defp split_segs(segs = [l | r]) when length(segs) <= 2 do
    if l.index < r.index,
      do: [l | r],
      else: [r | l]
  end

  defp split_segs(segs) do
    step = (length(segs) / 2) |> round()
    l = get_in(segs, [Access.filter(&(&1.index < step))])
    r = get_in(segs, [Access.filter(&(&1.index >= step))])
    [l | r]
  end

  # Setting Path #
  defp flatten_path(svg = %Path{}) do
    flat_path =
      svg.segments
      |> Enum.reduce([], fn element, acc ->
        List.insert_at(acc, element.index, element.svg)
      end)
      |> Enum.reduce("", &(&2 <> &1))
      |> String.trim_leading()

    %SVG{segments: svg.segments, path: flat_path}
  end

  def add_joint_seg(index, angle) do
  end

  # =================================
  #           Client API
  # =================================

  def make_svg(path) when is_binary(path) do
    GenServer.start_link(__MODULE__, path)
  end

  def push(pid, path) do
    GenServer.cast(pid, {:push, path})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  # maybe popping and pushing specific segments as well
  # I think i'll have a clearer picture on how to structure this
  # after setting up the supervisor module
  # then I can try and do a little animation set up

  # =================================
  #           Server API
  # =================================

  @impl true
  def init(path) do
    svg = order_segs(path)
    {:ok, svg}
  end

  @impl true
  def handle_call(:pop, _from, svg) do
    {:reply, svg}
  end
end

# can turn the name into a hash function for the supervisor
# {:ok, pid} = GenServer.start_link(Path, "M0 5 Q 45 -5, 70 5 T 120 5 V15 H0 Z", name: MyPath)

# SVG.order_segs(svg)

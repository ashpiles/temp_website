defmodule SVG.Path.Utility do
  alias SVG.Path.Seg, as: Seg

  # Refractor Utility Module
  # ========================
  # -[] make better to do list
  # -[] fix Types.alias() name to be more verbose
  # -[] struct paths
  # -[] refactor algorithims to use new SVG.Path.Types structs
  # -[] mapped_path_to_string()

  def string_to_path(string) do
    string
    |> path_to_seg()
    |> Enum.reduce([], fn element, acc ->
      List.insert_at(acc, element.index, element.seg)
    end)
  end

  def path_to_string(path) do
    path
    |> Enum.reduce("", fn element, acc ->
      points =
        Enum.reduce(element.points, "", &(&2 <> Integer.to_string(&1) <> " "))

      acc <> element.command <> " " <> points
    end)
    |> String.trim()
  end

  def string_to_indexed_path(string) do
    string
    |> path_to_seg()
    |> Enum.reduce([], fn element, acc ->
      List.insert_at(acc, element.index, {element.index, element.seg})
    end)
  end

  def indexed_path_to_string(path) do
    path
    |> Enum.reduce([], fn element, acc ->
      {index, seg} = element
      List.insert_at(acc, index, seg)
    end)
    |> path_to_string()
  end

  def string_to_mapped_path(string) do
    string
    |> path_to_seg()
    |> Enum.reduce(%{}, fn element, acc ->
      Map.merge(acc, %{"#{element.seg.command}-#{element.index}" => element.seg})
    end)
  end

  # I'll have to finish the mapped path once i get a better feel for how to handle
  # the hash functions. I'll understand how I want to flatten it when I'm working on
  # the animator / composer
  def mapped_path_to_string(path) do
    path
    |> Map.keys()
    |> Enum.reduce("", fn key, acc ->
      nil
    end)
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
      %{
        seg: %Seg{
          command: key,
          points:
            numbers
            |> String.split()
            |> Enum.map(&String.to_integer/1)
        },
        index: index
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
    split_segs(svg.segments)
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
  defp flatten_path(svg) do
    svg.segments
    |> Enum.reduce([], fn element, acc ->
      List.insert_at(acc, element.index, element.svg)
    end)
    |> Enum.reduce("", &(&2 <> &1))
    |> String.trim_leading()
  end

  def add_joint_seg(index, angle) do
  end

  # maybe popping and pushing specific segments as well
  # I think i'll have a clearer picture on how to structure this
  # after setting up the supervisor module
  # then I can try and do a little animation set up
end

SVG.Path.Utility.string_to_path("M0 5 Q 45 -5, 70 5 T 120 5 V15 H0 Z")
|> SVG.Path.Utility.path_to_string()
|> IO.inspect()

SVG.Path.Utility.string_to_indexed_path("M0 5 Q 45 -5, 70 5 T 120 5 V15 H0 Z")
|> SVG.Path.Utility.indexed_path_to_string()
|> IO.inspect()

SVG.Path.Utility.string_to_mapped_path("M0 5 Q 45 -5, 70 5 T 120 5 V15 H0 Z")
|> IO.inspect()

defmodule SVG do
  alias SVG.Path.Seg, as: Seg
  alias SVG.Path, as: Path

  # okay wait
  # what if I put the sigil api and the server api here
  # and then put the client and internal funcs here

  # =================================
  #            Sigil API
  # =================================

  def sigil_svg(string, []) do
    string
    |> path_to_seg()
    |> segs_to_svg()
    |> order_segs()
    |> flatten_path()
  end

  # =================================
  #           Client API
  # =================================

  # eventually will have to tie in composer api

  def make_svg(path) when is_binary(path) do
    GenServer.start_link(Path, path)
  end

  def push(pid, path) do
    GenServer.cast(pid, {:push, path})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end
end

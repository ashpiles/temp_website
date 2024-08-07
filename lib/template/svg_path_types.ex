defmodule SVG.Path.Seg do
  @type t :: %__MODULE__{
          command: String.t(),
          points: list(float())
        }
  defstruct command: ~c"", points: []
end

# most flexible
defmodule SVG.Path.StdPath do
  alias SVG.Path.Seg, as: Seg
  @type t :: %__MODULE__{path: list(Seg.t())}

  defstruct path: [%Seg{}]
end

# more granular, allows for grouping
defmodule SVG.Path.IndexedPath do
  alias SVG.Path.StdPath, as: StdPath
  @type t :: %__MODULE__{path: [{integer(), Seg.t()}]}
  defstruct path: [{0, %StdPath{}}]
end

# least flexible, for hash mapping and look up tables
defmodule SVG.Path.MappedPath do
  alias SVG.Path.StdPath, as: StdPath
  @type t :: %__MODULE__{path: [%{String.t() => StdPath.t()}]}
  defstruct path: [%{"" => %StdPath{}}]
end

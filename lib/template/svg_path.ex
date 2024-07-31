defprotocol SVG.Path do
  alias SVG.Path.Seg, as: Seg

  @doc """
  All possible svg path types
  """
  @type t :: StdPath.t() | IndexedPath.t() | MappedPath.t()

  @doc """
  Turns a string or existing svg path into a kind of svg path
  """
  @spec make_path(String.t() | t(), [any()]) :: t()
  def make_path(path, opts)

  @doc """
  Concatonates two svg paths of the same type
  """
  @spec concat(t(), t()) :: t()
  def concat(p1, p2)

  @doc """
  Subtracts elements of a svg path from another of the same type
  """
  @spec subtract(t(), t()) :: t()
  def subtract(p1, p2)

  @doc """
  Map a function to the segments of a svg path
  """
  @spec map(t(), (Seg.t() -> any())) :: t()
  def map(path, fun)

  @doc """
  Flatten a svg path into a correctly formatted string
  """
  @spec flatten(t()) :: String.t()
  def flatten(path)
end

defimpl SVG.Path, for: BitString do
  alias SVG.Path.Utility, as: Utility

  def make_path(path, opts) do
    case opts do
      :mapped -> Utility.string_to_mapped_path(path)
      :indexed -> Utility.string_to_indexed_path(path)
      :standard -> Utility.string_to_path(path)
      _ -> Utility.string_to_path(path)
    end
  end

  def subtract(p1, p2) do
    char_list1 = String.to_charlist(p1)
    char_list2 = String.to_charlist(p2)
    char_list1 -- char_list2
  end

  def concat(p1, p2) do
    char_list1 = String.to_charlist(p1)
    char_list2 = String.to_charlist(p2)
    char_list1 ++ char_list2
  end

  def map(path, fun) do
    char_list = String.to_charlist(path)
    Enum.map(char_list, fun)
  end

  def flatten(path) do
    String.trim(path)
  end
end

defimpl SVG.Path, for: StdPath do
  alias SVG.Path.Utility, as: Utility

  # I need a way to match for the regular path and the tuple

  def make_path(path, opts) do
    case opts do
      :mapped ->
        path
        |> Utility.path_to_string()
        |> Utility.string_to_mapped_path()

      :indexed ->
        path
        |> Utility.path_to_string()
        |> Utility.string_to_indexed_path()

      :standard ->
        path

      _ ->
        path
    end
  end

  def subtract(p1, p2) do
    char_list1 =
      p1
      |> Utility.path_to_string()
      |> String.to_charlist()

    char_list2 =
      p2
      |> Utility.path_to_string()
      |> String.to_charlist()

    (char_list1 -- char_list2)
    |> Utility.string_to_path()
  end

  def concat(p1, p2) do
    char_list1 =
      p1
      |> Utility.path_to_string()
      |> String.to_charlist()

    char_list2 =
      p2
      |> Utility.path_to_string()
      |> String.to_charlist()

    (char_list1 ++ char_list2)
    |> Utility.string_to_path()
  end

  def map(path, fun) do
    char_list =
      path
      |> Utility.path_to_string()
      |> String.to_charlist()

    Enum.map(char_list, fun)
  end

  def flatten(path) do
    path
    |> Utility.path_to_string()
  end
end

defimpl SVG.Path, for: IndexedPath do
  alias SVG.Path.Utility, as: Utility

  # I need a way to match for the regular path and the tuple

  def make_path(path, opts) do
    case opts do
      :mapped ->
        path
        |> Utility.indexed_path_to_string()
        |> Utility.string_to_mapped_path()

      :indexed ->
        path

      :standard ->
        path
        |> Utility.indexed_path_to_string()
        |> Utility.string_to_path()

      _ ->
        path
        |> Utility.indexed_path_to_string()
        |> Utility.string_to_path()
    end
  end

  def subtract(p1, p2) do
    char_list1 =
      p1
      |> Utility.indexed_path_to_string()
      |> String.to_charlist()

    char_list2 =
      p2
      |> Utility.indexed_path_to_string()
      |> String.to_charlist()

    (char_list1 -- char_list2)
    |> Utility.string_to_indexed_path()
  end

  def concat(p1, p2) do
    char_list1 =
      p1
      |> Utility.indexed_path_to_string()
      |> String.to_charlist()

    char_list2 =
      p2
      |> Utility.indexed_path_to_string()
      |> String.to_charlist()

    (char_list1 ++ char_list2)
    |> Utility.string_to_indexed_path()
  end

  def map(path, fun) do
    char_list =
      path
      |> Utility.indexed_path_to_string()
      |> String.to_charlist()

    Enum.map(char_list, fun)
  end

  def flatten(path) do
    path
    |> Utility.indexed_path_to_string()
  end
end

# handles a hashed path
defimpl SVG.Path, for: MappedPath do
  alias SVG.Path.Utility, as: Utility

  def make_path(path, opts) do
    case opts do
      :mapped ->
        path

      :indexed ->
        path
        |> Utility.mapped_path_to_string()
        |> Utility.string_to_indexed_path()

      _ ->
        path
        |> Utility.mapped_path_to_string()
        |> Utility.string_to_path()
    end
  end

  def subtract(p1, p2) do
    char_list1 =
      p1
      |> Utility.mapped_path_to_string()
      |> String.to_charlist()

    char_list2 =
      p2
      |> Utility.mapped_path_to_string()
      |> String.to_charlist()

    (char_list1 -- char_list2)
    |> Utility.string_to_mapped_path()
  end

  def concat(p1, p2) do
    char_list1 =
      p1
      |> Utility.mapped_path_to_string()
      |> String.to_charlist()

    char_list2 =
      p2
      |> Utility.mapped_path_to_string()
      |> String.to_charlist()

    (char_list1 -- char_list2)
    |> Utility.string_to_mapped_path()
  end

  def map(path, fun) do
    char_list =
      path
      |> Utility.mapped_path_to_string()
      |> String.to_charlist()

    Enum.map(char_list, fun)
  end

  def flatten(path) do
    Utility.mapped_path_to_string(path)
  end
end

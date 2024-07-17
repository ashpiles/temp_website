defmodule SVG.Composer do
  use Supervisor
  import SVG
  alias SVG.Animator
  # this will help compose multiple svgs
  # will allow for embedding functions as animations

  # ------------
  # To Do
  # ------------
  # -[] receive SVG intialization
  # -[] allow for svg creation and manipulation
  # -[] animator api funcs
end

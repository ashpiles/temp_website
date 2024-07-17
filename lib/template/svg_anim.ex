defmodule SVG.Animator do
  # will hook in with my custom java script to phx
  # communicates between the paths and this
  # allows for inlines and procedural graphics

  # because each path is already a gen server this will simply be a
  # module which composes the svgs with timed interpolation funcs

  # ------------
  # To Do
  # ------------
  # -[] timeline data type
  # -> difficult one, likely a struct of the fps and a list of frame data types
  # -[] frame data type
  # -> frame takes an animation and an extra timing decimal num
  # -> the extra timing is how + or - from the beat it will be
  # -> exceeding the range wraps the value around
  # -[] an animation data type
  # -> the svg(literal or refrence), the transformation(function + args)
  # -[] function that runs the animation
  # -[] functions that allow for hotswapping / modifying animations
end

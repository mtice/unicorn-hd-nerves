defmodule UnicornHathd do
  alias UnicornHathd.{
    Display,
    Matrix
  }
  @moduledoc """
  Documentation forUnicornHathd.
  """
  # use GenServer
  # defmodule Screen do
  #   defstruct [:display_pid, :empty_screen]
  # end

  @range 0..15
  # @color_values 0..255
  @red [255, 0, 0]
  @green [0, 255, 0]
  @blue [0, 0, 255]
  @white [255, 255, 255]


  def initialize() do
    empty_screen = Matrix.build_empty()
    Display.start(empty_screen)
  end

  def set_one(x, y, color, angle) do
    Display.get_screen
    |> Matrix.set_pixel(x, y, color, angle)
    |> Display.draw_and_save()
  end

  def clear_board() do
    Matrix.build_empty()
    |> Display.draw_and_save()
  end

  def send_to_screen() do
    Display.send_to_hat_hd()
  end

end

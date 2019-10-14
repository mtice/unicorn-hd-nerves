defmodule LineRotate do
  @moduledoc """
  Draws 3 lines in order: y=0, x=0, y=x.
  Then draws those lines rotated 90 degrees. Rinse. Repeat.

  Derived from this Python script: https://github.com/pimoroni/unicorn-hat-hd/blob/master/examples/line.py
  """


  use GenServer
  require Logger
  alias UnicornHathd.{
    Color,
    Matrix
  }
  @update_interval 50
  @color_rotation [Color.green, Color.blue, Color.red]
  @angle_rotation [0, 90, 180, 270]
  @line_rotation [:line_x, :line_y, :slope_1]

  defmodule State do
    defstruct [:timer, :point_buffer, :line_buffer, :curr_line, :curr_color, :curr_angle, :angle_queue, :color_queue]
  end

  #@range 0..15
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    UnicornHathd.initialize()

    [first_angle | angle_tail] = @angle_rotation
    [first_color | color_tail] = @color_rotation
    [first_line | line_tail] = @line_rotation
    curr_point_buffer = line_x(0)

    timer_ref = Process.send_after(self(), :draw_next, @update_interval)

    state = %State{
      timer: timer_ref,
      point_buffer: curr_point_buffer,
      line_buffer: line_tail,
      curr_line: first_line,
      curr_color: first_color,
      curr_angle: first_angle,
      angle_queue: angle_tail ++ [first_angle],
      color_queue: color_tail ++ [first_color]
    }

    {:ok, state}
  end

  @doc """
  Params:
  point: {x,y}
  angle: An angle at which to rotate the point about {0,0}
  color: A UnicornHathd.Color (or 0..255::[r,g,b] value)
  """
  def draw_point({x, y}, angle, color \\ Color.red) do
    UnicornHathd.set_one(x, y, color, angle)
    UnicornHathd.send_to_screen()
    Process.send_after(self(), :draw_next, @update_interval)
  end


  #
  # Draw with all curr_values in State.
  # If anything out of bounds, reset.
  #
  @impl true
  def handle_info(:draw_next, state) do

    curr_point = List.first(state.point_buffer)
    curr_line = List.first(state.line_buffer)

    cond do
      curr_line == nil && curr_point == nil ->
        #
        # - clear board
        # - update angle
        # - re-create line_buffer and point_buffer
        # - draw first point in point_buffer
        UnicornHathd.clear_board

        [first_line | line_tail] = @line_rotation
        [next_angle | angle_tail] = state.angle_queue
        [first_point | point_tail] = line_x(0)
        [next_color | color_tail] = state.color_queue

        draw_point(first_point, next_angle, next_color)
        next_state = %State{state |
          point_buffer: point_tail,
          curr_line: first_line,
          curr_color: next_color,
          curr_angle: next_angle,
          angle_queue: angle_tail ++ [next_angle],
          color_queue: color_tail ++ [next_color],
          line_buffer: line_tail
        }
        {:noreply, next_state}
      curr_point == nil ->
        #
        # point buffer is empty.
        # - Refill it by calling next line creation function
        # - Change color
        #

        [next_line | line_tail] = state.line_buffer
        [next_point | point_tail] = apply(__MODULE__, next_line, [0])


        [next_color | color_tail] = state.color_queue

        draw_point(next_point, state.curr_angle, next_color)
        next_state = %State{state |
          point_buffer: point_tail,
          curr_line: next_line,
          curr_color: next_color,
          color_queue: color_tail ++ [next_color],
          line_buffer: line_tail
        }
        {:noreply, next_state}
      true ->
        # Draw next point in buffer

        [next_point | point_tail] = state.point_buffer

        draw_point(next_point, state.curr_angle, state.curr_color)
        {:noreply, %{state | point_buffer: point_tail}}
    end
  end

  @doc """
    Make a list of points that define the horizontal line that intersects {0, y}
  """
  def line_x(y) do
    Matrix.row_points(y, 0)
  end

  @doc """
    Make a list of points that define the vertical line that intersects {x, 0}
  """
  def line_y(x) do
    Matrix.col_points(x, 0)
    # IO.inspect(line_y_to_draw, label: "LINE_Y() will draw")
  end

  @doc """
    Make a list of points that define the line y=x
  """
  def slope_1(_) do
    Enum.zip(0..15, 0..15) |> Enum.map(fn {x, y} -> Matrix.rotate(x, y, 0) end)
  end

  # def make_horizontal_coords() do
  #   Enum.zip(@range, @range)
  # end
  # def draw_coords() do
  #   make_horizontal_coords()
  #   |> Enum.each(fn {x, y} -> draw_point(x, y, Color.white) end)
  # end
end

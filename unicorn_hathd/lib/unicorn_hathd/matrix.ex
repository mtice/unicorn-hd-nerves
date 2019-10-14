defmodule UnicornHathd.Matrix do
  alias UnicornHathd.{
    Color
  }
  @rows 0..15
  @size 15
  def build_empty() do
    Enum.reduce(@rows, [], fn(_, acc) -> acc ++ [new_row()] end)
  end

  def build_color_fill(color \\ Color.off) do
    Enum.reduce(@rows, [], fn(_, acc) -> acc ++ [color] end)
  end

  def new_row(color \\ Color.off) do
    Enum.reduce(@rows, [], fn (_, acc) -> acc ++ [color] end)
  end

  def set_color_in_column(column, y, color) do
    List.replace_at(column, y, color)
  end

  def set_pixel(screen, x, y, color, angle) do
    {x1, y1} = rotate(x, y, angle)
    row_to_update = Enum.at(screen, x1)
    updated = set_color_in_column(row_to_update, y1, color)
    List.replace_at(screen, x1, updated)
  end

  def flip_180(screen) do
    Enum.map(screen, fn x -> Enum.reverse(x) end)
  end

  def row_points(y) do
    Stream.zip(0..15, Stream.cycle([y])) |> Enum.to_list
  end

  def col_points(x, angle) do
    Stream.zip(Stream.cycle([x]), 0..15)
    |> Enum.to_list()
    |> Enum.map(fn {x, y} -> rotate(x, y, angle) end)
  end

  def row_points(y, angle) do
    Stream.zip(0..15, Stream.cycle([y]))
    |> Enum.to_list()
    |> Enum.map(fn {x, y} -> rotate(x, y, angle) end)
  end

  def rotate(x0, y0, 0), do: {x0, y0}

  def rotate(x0, y0, angle) do
    radians = :math.pi() * angle / 180.0
    cos = :math.cos(radians) |> Float.round(0) |> trunc
    sin = :math.sin(radians) |> Float.round(0) |> trunc
    re_center_shift = @size/2

    x0_shift = x0 - re_center_shift
    y0_shift = y0 - re_center_shift

    x1 = x0_shift * cos - y0_shift * sin
    y1 = y0_shift * cos + x0_shift * sin

    {round(x1 + re_center_shift) , round(y1 + re_center_shift)}
  end

  def trim_point_list(points) do
    Enum.filter(points, fn {x, y} -> (x < 16 && y < 16) end)
  end

end

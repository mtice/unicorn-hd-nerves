defmodule UnicornHathd.Color do


  @pixel_off [0, 0, 0]
  @pixel_white [255, 255, 255]

  @pixel_red [255, 0, 0]
  @pixel_green [0, 255, 0]
  @pixel_blue [0, 0, 255]


  @color_options %{
    :pixel_off => @pixel_off,
    :pixel_white => @pixel_white,
    :pixel_red => @pixel_red,
    :pixel_green => @pixel_green,
    :pixel_blue => @pixel_blue
  }

  def off do
    @pixel_off
  end

  def white do
    @pixel_white
  end

  def red do
    @pixel_red
  end

  def green do
    @pixel_green
  end

  def blue do
    @pixel_blue
  end
  def get_color_options do
    @color_options
  end

  def get_color(option) do
    Map.get(@color_options, option)
  end

  def make_color(r, g, b) do
    [r, g, b]
  end

end

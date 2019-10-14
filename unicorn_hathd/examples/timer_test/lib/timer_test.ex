defmodule TimerTest do

  use GenServer
  require Logger
  alias UnicornHathd.{
    Color,
    Matrix
  }

  @update_interval 20
  @columns 0..15
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    col_buffer = Matrix.row_points(0)
    t_ref = draw_buffer()
    {:ok, %{buffer: col_buffer, timer_ref: t_ref, column: 0}}
  end

  def draw_buffer do
    Logger.debug("draw_buffer")
    Process.send_after(self(), :draw_next, @update_interval)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_head, _from, state) do
    if (List.first(state.buffer) == nil) do
      {:replay, List.first(state.buffer), state}
    else
      [head | tail] = state.buffer
      {:reply, head, state}
    end

  end

  def handle_info(:draw_next, state) do
    next_column = state.column + 1
    next_point = List.first(state.buffer)
    cond do
      state.column not in @columns ->
        # IO.puts("STARTING OVER... ")
        start_buffer = Matrix.row_points(0)
        draw_buffer()
        {:noreply, %{state | buffer: start_buffer, column: 0}}
      next_point == nil ->
        # IO.inspect(next_column, label: ".. NEXT COLUMN()")
        next_buffer = Matrix.row_points(next_column)
        draw_buffer()
        {:noreply, %{state | buffer: next_buffer, column: next_column}}
      true ->
        [head | tail] = state.buffer
        # IO.inspect(head, label: ">> draw head")
        draw_buffer()
        {:noreply, %{state | buffer: tail}}
    end
  end
end

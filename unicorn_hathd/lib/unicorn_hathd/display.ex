defmodule UnicornHathd.Display do

  @moduledoc """
  Documentation for UnicornHathd.Display

  This handles all connection to the UnicornHatHD board through SPI.
  """

  alias Circuits.SPI

  # use GenServer

  defmodule State do
    defstruct [:spi_ref, :screen]
  end

  def start(initial_screen) do
    {:ok, spi_ref} = SPI.open("spidev0.0", mode: 0, speed_hz: 9_000_000)
    GenServer.start_link(__MODULE__, %State{spi_ref: spi_ref, screen: initial_screen}, name: __MODULE__)
  end

  def init(opts \\ []) do
    {:ok, opts}
  end

  def get_screen() do
   state = GenServer.call(__MODULE__, :get_state)
   state.screen
  end

  def draw_and_save(new_screen) do
    GenServer.cast(__MODULE__, {:update_screen, new_screen})
  end

  def send_to_hat_hd(hat_colors) do
    GenServer.cast(__MODULE__, {:update_screen, hat_colors})
    state = GenServer.call(__MODULE__, :get_state)
    SPI.transfer(state.spi_ref, format_for_spi(hat_colors))
  end
  def send_to_hat_hd() do
    get_screen()
    |> send_to_hat_hd
  end



  def format_for_spi(list) do
    List.flatten(list)
    |> Enum.reduce(<<114>>, fn(x, acc) -> acc <> <<x>> end)
  end


  #
  #CALL HANDLERS
  #
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update_screen, new_screen}, state) do
    {:noreply, %State{state | screen: new_screen}}
  end
end

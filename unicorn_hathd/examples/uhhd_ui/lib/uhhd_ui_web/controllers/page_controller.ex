defmodule UhhdUiWeb.PageController do
  use UhhdUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

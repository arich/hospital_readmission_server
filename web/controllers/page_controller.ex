defmodule HospitalReadmissionServer.PageController do
  use HospitalReadmissionServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

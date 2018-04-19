defmodule Enumerest.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Logger
  plug :match
  plug :dispatch

  post "request/reset" do
    Enumerest.Counter.reset
    send_resp(conn, 200, ":ok\n")
  end

  post "request/:id" do
    count =
      id
      |> Enumerest.Counter.count
      |> Integer.to_string

    send_resp(conn, 200, "#{count}\n")
  end

  get "summary" do
    summary =
      Enumerest.Counter.summary
      |> Poison.encode!

    send_resp(conn, 200, summary)
  end

  match _ do
    send_resp(conn, 404, "oops\n")
  end

  def handle_errors(conn, %{ kind: _kind, reason: _reason, stack: _stack }) do
    send_resp(conn, conn.status, "srydave\n")
  end
end

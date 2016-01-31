defmodule Ginjyo.FileController do
  use Ginjyo.Web, :controller
  require Logger

  alias Ginjyo.Asset

  plug Ginjyo.Plugs.AllowUser when action in [:file_upload, :index]

  def index(conn, %{"page" => page}) do
    pages = Asset
    |> Repo.paginate(page_size: 20, page: page)
    render conn, "index.html", pages: pages
  end

  def index(conn, _) do
    pages = Asset
    |> Repo.paginate(page_size: 20)
    render conn, "index.html", pages: pages
  end

  def file_upload(conn, %{"session" => session}) do
    case session["image"] do
      %Plug.Upload {content_type: content_type, filename: filename, path: path} ->
        case File.read path do
          {:ok, image} ->
            upload_filename = Application.get_env(:ginjyo, :upload_path) <> filename
            if File.exists? upload_filename do
                conn
                |> put_flash(:error, "Already exist same name file!")
                |> redirect(to: file_path(conn, :index))
                |> halt
            else
              case File.open upload_filename, [:write] do
                {:ok, file} ->
                  IO.binwrite file, image
                  File.close file
                  case File.stat(upload_filename) do
                    {:ok, stat}->
                      changeset = Asset.changeset(
                        %Asset{},
                        %{
                          content_type: content_type,
                          filename: filename,
                          filesize: stat.size
                        }
                      )
                      Repo.insert(changeset)
                      conn
                      |> put_flash(:info, "Uploaded File.")
                      |> redirect(to: file_path(conn, :index))
                    {:error, _} ->
                      conn
                      |> put_flash(:info, "Cant't Get Stat. Asset is not saved.")
                      |> redirect(to: file_path(conn, :index))
                  end
                {:error, _} ->
                    conn
                    |> put_flash(:info, "Can't upload File. Asset is not saved.")
                    |> redirect(to: file_path(conn, :index))
              end
            end
          {:error, _} ->
            conn
            |> put_flash(:error, "Can't read File")
            |> redirect(to: file_path(conn, :index))
        end
      _ ->
        conn
        |> put_flash(:error, "Worng format.")
        |> redirect(to: file_path(conn, :index))
    end
  end

end

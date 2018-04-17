defmodule Mix.Tasks.Hookex.Uninstall do
  use Mix.Task

  alias Hookex.Uninstaller

  @preferred_cli_env :dev

  def run(_) do
    Uninstaller.uninstall()
  end
end

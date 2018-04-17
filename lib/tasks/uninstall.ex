defmodule Mix.Tasks.Hookex.Uninstall do
  use Mix.Task

  alias Hookex.Installer

  @preferred_cli_env :dev

  def run(_) do
    Installer.uninstall()
  end
end

defmodule Mix.Tasks.Hookex.Install do
  use Mix.Task

  alias Hookex.Installer

  @preferred_cli_env :dev

  def run(_) do
    Installer.install()
  end
end

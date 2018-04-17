defmodule Mix.Tasks.Hookex do
  use Mix.Task

  @preferred_cli_env :dev

  def run(_) do
    Hookex.install_hooks()
  end
end

defmodule Mix.Tasks.Hookex do
  use Mix.Task

  def run(_) do
    Hookex.install_hooks()
  end
end

defmodule Mix.Tasks.Hookex.Run do
  use Mix.Task

  alias Hookex.Runner

  @preferred_cli_env :dev

  def run(args) do
    [command | params] = args
    Runner.run(command, params)
  end
end

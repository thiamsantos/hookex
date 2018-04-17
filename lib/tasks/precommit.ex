defmodule Mix.Tasks.Precommit do
  use Mix.Task

  def run(args) do
    IO.inspect("precommit")
    Mix.shell.info Enum.join(args, " ")
  end
end

defmodule Hookex do
  @moduledoc """
  Documentation for Hookex.
  """

  alias Hookex.Installer

  def install_hooks do
    IO.puts("hookex > setting up git hooks")

    Installer.install()

    IO.puts("hookex > done")
  end
end

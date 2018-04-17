defmodule Hookex do
  @moduledoc """
  Documentation for Hookex.
  """
  alias Hookex.Installer

  def install_hooks do
    IO.puts("[info] setting up git hooks")

    Installer.install()

    IO.puts("[info] done")
  end
end

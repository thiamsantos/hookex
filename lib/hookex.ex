defmodule Hookex do
  @moduledoc """
  Documentation for Hookex.
  """
  alias Hookex.Installer

  def install_hooks do
    Installer.install()
  end
end

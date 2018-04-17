defmodule Hookex.Utils do
  @moduledoc false

  def basepath, do: Path.join(".git", "hooks")

  def identifier, do: "hookex"

  def hooks do
    [
      "applypatch-msg",
      "pre-applypatch",
      "post-applypatch",
      "pre-commit",
      "prepare-commit-msg",
      "commit-msg",
      "post-commit",
      "pre-rebase",
      "post-checkout",
      "post-merge",
      "pre-push",
      "pre-receive",
      "update",
      "post-receive",
      "post-update",
      "push-to-checkout",
      "pre-auto-gc",
      "post-rewrite",
      "sendemail-validate"
    ]
  end

  def verify_folder_exists(path) do
    case File.exists?(path) do
      true -> :ok
      false -> :error
    end
  end

  def get_hook_path(name) do
    basepath()
    |> Path.join(name)
  end
end

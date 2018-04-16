defmodule Hookex.Installer do
  @basepath Path.join(".git", "hooks")
  @version Hookex.MixProject.project[:version]
  @identifier "hookex"

  def install do
    hooks()
    |> Enum.filter(&hook_exists?/1)
    |> Enum.each(&create_hook/1)
  end

  defp create_hook(name) do
    path = Path.join(@basepath, name)

    template =
      Hookex.Template.hook(
        identifier: @identifier,
        task_name: get_task_name(name),
        version: @version
      )

    {:ok, file} = File.open(path, [:write])
    IO.binwrite(file, template)
    File.close(file)
  end

  defp hook_exists?(name) do
    name
    |> get_task_name()
    |> Mix.Task.get()
    |> is_not_nil()
  end

  defp get_task_name(hook_name) do
    hook_name
    |> String.replace("-", "")
  end

  defp is_not_nil(nil), do: false
  defp is_not_nil(_), do: true

  defp hooks do
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
end

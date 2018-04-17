defmodule Hookex.Installer do
  @basepath Path.join(".git", "hooks")
  @version Hookex.MixProject.project[:version]
  @identifier "hookex"

  def install do
    hooks()
    |> Enum.filter(&task_exists?/1)
    |> Enum.each(&create_hook/1)

    :ok
  end

  defp create_hook(name) do
    path = Path.join(@basepath, name)

    File.exists?(path)
    |> handle_file_exists(path)
    |> build_hook(name, path)
  end

  defp build_hook({:ok, :update_hook}, name, path) do
    IO.puts("[info] updating hook: #{name}")
    do_build_hook(name, path)
  end

  defp build_hook({:ok, :hook_not_found}, name, path) do
    IO.puts("[info] creating hook: #{name}")
    do_build_hook(name, path)
  end

  defp build_hook({:ok, :skip_hook}, name, _path) do
    IO.puts("[info] skipping existing user hook: #{name}")
  end

  defp do_build_hook(name, path) do
    template =
      Hookex.Template.hook(
        identifier: @identifier,
        task_name: get_task_name(name),
        version: @version
      )

    {:ok, file} = File.open(path, [:write])
    :ok = IO.binwrite(file, template)
    :ok = File.close(file)
    :ok = File.chmod(path, 0o755)
  end

  defp handle_file_exists(true = _exists, path) do
    {:ok, content} = File.read(path)

    case String.contains?(content, @identifier) do
      true -> {:ok, :update_hook}
      false -> {:ok, :skip_hook}
    end
  end

  defp handle_file_exists(false = _exists, _path) do
    {:ok, :hook_not_found}
  end

  defp task_exists?(name) do
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

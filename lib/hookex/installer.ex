defmodule Hookex.Installer do
  @basepath Path.join(".git", "hooks")
  @version Hookex.MixProject.project[:version]
  @identifier "hookex"

  def install do
    IO.puts("[info] Setting up git hooks.")

    @basepath
    |> verify_folder_exists()
    |> install_hooks()
  end

  def uninstall do
    IO.puts("[info] Uninstalling git hooks.")

    @basepath
    |> verify_folder_exists()
    |> uninstall_hooks()
  end


  defp uninstall_hooks(:ok) do
    hooks()
    |> Enum.map(&get_hook_path/1)
    |> Enum.filter(fn(hook) -> File.exists?(hook) end)
    |> Enum.each(&delete_hook/1)

    IO.puts("[info] Done.")
    :ok
  end

  defp uninstall_hooks(:error) do
    IO.puts("[error] Can't find .git/hooks directory.")
    IO.puts("[info] Skipping git hooks uninstall.")
    :error
  end

  defp delete_hook(hook) do
    name = Path.basename(hook)
    IO.puts("[info] Deleting #{name} hook.")
    :ok = File.rm(hook)

    :ok
  end

  defp install_hooks(:ok) do
    hooks()
    |> Enum.filter(&task_exists?/1)
    |> Enum.each(&create_hook/1)

    IO.puts("[info] Done.")
    :ok
  end

  defp install_hooks(:error) do
    IO.puts("[error] Can't find .git/hooks directory.")
    IO.puts("[info] Skipping git hooks installation.")
    :error
  end

  defp verify_folder_exists(path) do
    case File.exists?(path) do
      true -> :ok
      false -> :error
    end
  end

  defp create_hook(name) do
    path = get_hook_path(name)

    File.exists?(path)
    |> handle_file_exists(path)
    |> build_hook(name, path)
  end

  defp get_hook_path(name) do
    Path.join(@basepath, name)
  end

  defp build_hook({:ok, :update_hook}, name, path) do
    IO.puts("[info] Updating #{name} hook.")
    do_build_hook(name, path)
  end

  defp build_hook({:ok, :hook_not_found}, name, path) do
    IO.puts("[info] Creating #{name} hook.")
    do_build_hook(name, path)
  end

  defp build_hook({:ok, :skip_hook}, name, _path) do
    IO.puts("[info] Skipping existing user #{name} hook.")
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

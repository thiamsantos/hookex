defmodule Hookex.Uninstaller do
  alias Hookex.Utils

  def uninstall do
    IO.puts("[info] Uninstalling git hooks.")

    Utils.basepath()
    |> Utils.verify_folder_exists()
    |> uninstall_hooks()
  end

  defp uninstall_hooks(:ok) do
    Utils.hooks()
    |> Enum.map(&Utils.get_hook_path/1)
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
end

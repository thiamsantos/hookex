defmodule Hookex.Runner do
  def run(command, params) do
    IO.puts("[info] Running #{command} hook.")
    exit_status = Mix.Shell.IO.cmd("mix #{command} #{Enum.join(params, " ")}")

    unless exit_status == 0 do
      IO.puts("[error] #{command} hook failed #{no_verify_message(command)}")
    end

    exit({:shutdown, exit_status})
  end

  defp no_verify_message("preparecommitmsg") do
    "(cannot be bypassed with --no-verify due to Git specs)"
  end
  defp no_verify_message(_command) do
    "(add --no-verify to bypass)"
  end
end

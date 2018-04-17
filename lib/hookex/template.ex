defmodule Hookex.Template do
  @moduledoc false
  require EEx
  EEx.function_from_file(:def, :hook, Path.join("priv", "hook.eex"), [:assigns])
end

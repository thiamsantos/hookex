defmodule Hookex.Template do
  require EEx
  EEx.function_from_file(:def, :hook, Path.join("priv", "hook.eex"), [:assigns])
end

local version = vim.version

if version.ge == nil then
  local function coords(ver)
    if type(ver) == "table" then
      local major = ver.major or ver[1] or 0
      local minor = ver.minor or ver[2] or 0
      local patch = ver.patch or ver[3] or 0
      return major, minor, patch
    end

    local current = version()
    return current.major or 0, current.minor or 0, current.patch or 0
  end

  ---@param current table
  ---@param other table
  function version.ge(current, other)
    local cur_major, cur_minor, cur_patch = coords(current)
    local tgt_major, tgt_minor, tgt_patch = coords(other)

    if cur_major ~= tgt_major then
      return cur_major > tgt_major
    end

    if cur_minor ~= tgt_minor then
      return cur_minor > tgt_minor
    end

    return cur_patch >= tgt_patch
  end
end

local lsp = vim.lsp
if lsp and lsp.enable == nil then
  local function as_list(value)
    if type(value) == "table" then
      return value
    end
    return { value }
  end

  function lsp.enable(name, enable)
    if enable == false then
      return
    end

    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
      return
    end

    for _, server in ipairs(as_list(name)) do
      local cfg = lspconfig[server]
      if cfg and cfg.manager and cfg.manager.try_add_wrapper then
        cfg.manager:try_add_wrapper()
      end
    end
  end

  if lsp.is_enabled == nil then
    function lsp.is_enabled()
      return false
    end
  end
end

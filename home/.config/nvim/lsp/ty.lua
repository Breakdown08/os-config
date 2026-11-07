return {
    -- ty from the project's .venv (the version pinned in uv.lock, same as CI), else the system one.
    cmd = function(dispatchers, config)
        local root = config.root_dir
        local venv_ty = root and vim.fs.joinpath(root, ".venv", "bin", "ty")
        local exe = (venv_ty and vim.fn.executable(venv_ty) == 1) and venv_ty or "ty"
        return vim.lsp.rpc.start({ exe, "server" }, dispatchers, { cwd = root })
    end,
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
}

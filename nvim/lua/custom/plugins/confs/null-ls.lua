local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {
	b.formatting.verible_verilog_format,
	b.formatting.stylua,
	b.formatting.clang_format,
	b.formatting.scalafmt,
	b.formatting.rustfmt,
	b.formatting.black,
}

null_ls.setup({
	debug = true,
	sources = sources,
})

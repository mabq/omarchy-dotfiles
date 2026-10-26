return {
  "EskelinenAntti/omarchy-theme.nvim",
  priority = 1000, -- ensure it loads early
  config = function()
    -- Automatically use Omarchy theme if running inside Omarchy
    if require("omarchy-theme.environment").is_omarchy() then
      vim.cmd.colorscheme("omarchy")
    else
      vim.cmd.colorscheme("tokyonight") -- Fallback for non-Omarchy systems
    end
  end,
}

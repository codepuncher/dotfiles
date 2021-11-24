return {
  lintCommand = './vendor/bin/phpcs --standard=PSR12 --report=emacs -s - ${INPUT}',
  lintIgnoreExitCode = true,
  lintStdin = true,
  -- lintFormats = {
  --   '%f(%l,%c): %tarning %m',
  --   '%f(%l,%c): %rror %m',
  -- },
  lintSource = "phpcs",
  -- formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
  -- formatStdin = true,
}

return {
    lintSource = 'phpcs',
    lintCommand = [[$([ -n "$(command -v vendor/bin/phpcs)" ] && echo 'vendor/bin/phpcs' || echo 'phpcs') --standard=PSR12 --report=emacs -s - ${INPUT}]],
    lintIgnoreExitCode = true,
    lintStdin = true,
    -- lintFormats = {
    --   '%f(%l,%c): %tarning %m',
    --   '%f(%l,%c): %rror %m',
    -- },
    -- formatCommand = [[$([ -n "$(command -v vendor/bin/phpcbf)" ] && echo 'vendor/bin/phpcbf' || echo 'phpcbf') --standard=PSR12 - ${INPUT}]],
    formatSource = 'phpcbf',
    formatCommand = 'phpcbf --standard=PSR12 -q --stdin-path=${INPUT} -', -- This should work but doesn't...
    formatIgnoreExitCode = true,
    formatStdin = true
}

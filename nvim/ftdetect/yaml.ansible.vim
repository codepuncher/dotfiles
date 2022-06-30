function s:isAnsible()
  let filepath = expand('%:p')
  if filepath =~ '\v/(tasks|roles|handlers)/.*\.ya?ml$' | return 1 | en
  if filepath =~ '\v/(group|host)_vars/' | return 1 | en
  if filepath =~ '\v/trellis/' | return 1 | en
endfunction

au BufRead,BufNewFile * if s:isAnsible() | set filetype=yaml.ansible | en

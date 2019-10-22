" COMBO Counter
let g:combo_counter = 0
let g:best_combo = readfile('/home/$USER/.vim/.combo')
let g:best_combo = g:best_combo[0]
let g:last_combo = reltime()
let g:airline_section_b = 'ᛥ %{g:combo_counter} [%{g:best_combo}]'
function! UpdateCombo()
  if reltimefloat(reltime(g:last_combo)) > 1
	  let g:combo_counter = 1
  else
	  let g:combo_counter +=1
	  if g:combo_counter > g:best_combo
		call writefile([g:combo_counter], "/home/$USER/.vim/.combo")
		let g:best_combo = g:combo_counter
	  endif
  endif
  let g:last_combo = reltime()
endfunction
autocmd CursorMovedI * call UpdateCombo()

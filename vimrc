" COMBO Counter
let g:combo_counter = 0								" The actual combo variable
let g:best_combo = readfile('/home/$USER/.vim/.combo')				" ~ is not expanded ???
let g:best_combo = g:best_combo[0]						" Reading from file returns a list, but an int is needed
let g:last_combo = reltime()							" Set current time as last combo time
let g:airline_section_b = 'ᛥ %{g:combo_counter} [%{g:best_combo}]'		" I use airline vim and inserted the combo meter in it
function! UpdateCombo()
  if reltimefloat(reltime(g:last_combo)) > 1					" Timeout is 1 second
	  if g:combo_counter > g:best_combo					" Before resetting combo counter, check if new high score
		call writefile([g:combo_counter], "/home/$USER/.vim/.combo")
		let g:best_combo = g:combo_counter
	  endif
	  let g:combo_counter = 1
  else
	  let g:combo_counter +=1 
  endif
  let g:last_combo = reltime()
endfunction
autocmd CursorMovedI * call UpdateCombo()					" Every time the cursor moves, call combo function

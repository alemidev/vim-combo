" COMBO Counter
let g:disable_combo = 0
" Combo counting is disabled in plain text, LaTeX, vim config and files
" without extension (usually configuration files)
if expand("%:e") == "txt" || expand("%:e") == "tex" || expand("%:e") == "vim" || expand("%:e") == ""
	let g:disable_combo = 1
endif

if g:disable_combo == 1
	let g:best_combo = readfile('$HOME/.vim/.combo')
	let g:best_combo = g:best_combo[0]
	let g:airline_section_b = 'ᛥ [%{g:best_combo}]'
else
	let g:combo_counter = 0							" The actual combo variable
	let g:best_combo = readfile('$HOME/.vim/.combo')			" ~ is not expanded ???
	let g:best_combo = g:best_combo[0]					" Reading from file returns a list, but an int is needed
	let g:last_combo = reltime()						" Set current time as last combo time
	let g:airline_section_b = 'ᛥ %{g:combo_counter} [%{g:best_combo}]'	" I use airline vim and inserted the combo meter in it
	function! UpdateCombo()
		if reltimefloat(reltime(g:last_combo)) > 1		" Timeout is 1 second
			if g:combo_counter > g:best_combo		" Before resetting combo counter, check if new high score
				call writefile([g:combo_counter], "$HOME/.vim/.combo")
				let g:best_combo = g:combo_counter
			endif
			let g:combo_counter = 1
		else
			let g:combo_counter +=1 
		endif
		let g:last_combo = reltime()
	endfunction
	autocmd TextChangedI * call UpdateCombo()	" Every time text in the file changes, call combo function
endif

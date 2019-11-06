" COMBO Counter
" Choose combo file depending on extension
if strlen(expand("%:e")) > 0
	let g:combo_file = $HOME . '/.vim/.combo/' . expand("%:e") . ".cmb"
else
	let g:combo_file = $HOME . '/.vim/.combo/none.cmb'
endif

" Find best score across all filetypes
let scores = []
for f in split(globpath($HOME . '/.vim/.combo/', '*'), '\n')
	let buf = readfile(f)
	call insert(scores, buf[0])
endfor
let g:best_combo_all = max(scores)

" Checking for ignored extensions
let ignored = ['cmb']
let g:disable_combo = 0
for f in ignored
	if expand("%:e") == f
		let g:disable_combo = 1
	endif
endfor

" If file should be ignored, just set text, else continue with script
if g:disable_combo
	let g:airline_section_b = airline#section#create(['[%{g:best_combo_all}] - ᛥ'])
else
	" Find best score for current filetype
	if filereadable(g:combo_file)
		let g:best_combo = readfile(g:combo_file)
		let g:best_combo = g:best_combo[0]
	else
		silent !echo 0 > $HOME/.vim/.combo/%:e.cmb
		let g:best_combo = 0
	endif
	let g:best_last_combo = g:best_combo		" Used to revert

	" Configure variables
	let g:combo_counter = 0		" The actual combo variable
	let g:timeout = 1
	hi User1 ctermfg=247 ctermbg=237
	let g:status = '%1*[%{g:best_combo}] %{g:combo_counter} ᛥ%#airline_b#'
	let g:status_max = '%1*[%{g:best_combo_all}|%{g:best_combo}] %{g:combo_counter} ᛥ%#airline_b#'
	command ComboMaxOn let g:airline_section_b = airline#section#create([g:status_max]) | AirlineRefresh
	command ComboMaxOff let g:airline_section_b = airline#section#create([g:status]) | AirlineRefresh
	let g:airline_section_b = airline#section#create([g:status])

	let g:last_combo = reltime()	" Set current time as last combo time
	function! UpdateCombo()
		if reltimefloat(reltime(g:last_combo)) > g:timeout
			call SaveCombo()
			let g:combo_counter = 1
		else
			let g:combo_counter +=1
		endif
		call UpdateColor()
		let g:last_combo = reltime()
	endfunction
	function! SaveCombo()		" Should check inside because it can be called on InsertLeave
		if g:combo_counter > g:best_combo
			call writefile([g:combo_counter], g:combo_file)
			let g:best_last_combo = g:best_combo
			let g:best_combo = g:combo_counter
		endif
	endfunction
	function! UpdateColor()
		if g:combo_counter == 1
			hi User1 ctermfg=247 ctermbg=237
		elseif g:combo_counter == 10
			hi User1 ctermfg=2 ctermbg=237
		elseif g:combo_counter == 30
			hi User1 ctermfg=6 ctermbg=237
		elseif g:combo_counter == 50
			hi User1 ctermfg=5 ctermbg=237
		elseif g:combo_counter == 70
			hi User1 ctermfg=3 ctermbg=237
		elseif g:combo_counter == 100
			hi User1 ctermfg=1 ctermbg=237
		endif
	endfunction
	function! Cheated()
		call writefile([g:best_last_combo], g:combo_file)
		let g:best_combo = g:best_last_combo
	endfunction

	autocmd TextChangedI * call UpdateCombo()	" Every time text is changed, call combo function
	autocmd InsertLeave * call SaveCombo()
endif

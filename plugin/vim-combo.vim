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

" Find best score for current filetype
if filereadable(g:combo_file)
        let g:best_combo = readfile(g:combo_file)
	let g:best_combo = g:best_combo[0]
else
	silent !echo 0 > $HOME/.vim/.combo/%:e.cmb
	let g:best_combo = 0
endif

" Configure variables
let g:combo_counter = 0							" The actual combo variable
let g:timeout = 1
let g:last_combo = reltime()						" Set current time as last combo time
let g:airline_section_b = 'ᛥ %{g:combo_counter}|%{g:best_combo} [%{g:best_combo_all}]'	" I use airline vim and inserted the combo meter in it
function! UpdateCombo()
	if reltimefloat(reltime(g:last_combo)) > g:timeout		" Timeout is 1 second
		call SaveCombo()
		let g:combo_counter = 1
	else
		let g:combo_counter +=1 
	endif
	let g:last_combo = reltime()
endfunction
function! SaveCombo()
	if g:combo_counter > g:best_combo
		call writefile([g:combo_counter], g:combo_file)
		let g:best_combo = g:combo_counter
	endif
endfunction

autocmd TextChangedI * call UpdateCombo()	" Every time the cursor moves, call combo function
autocmd InsertLeave * call SaveCombo()

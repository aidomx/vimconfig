" Android Development Settings
let g:android_sdk_path = $ANDROID_HOME

" Kotlin configuration
autocmd FileType kotlin setlocal shiftwidth=2 tabstop=2

" Java configuration
autocmd FileType java setlocal shiftwidth=2 tabstop=2

" Build commands untuk Android
command! -nargs=* GradleBuild execute '!./gradlew build'
command! -nargs=* GradleTest execute '!./gradlew test'
command! -nargs=* GradleAssemble execute '!./gradlew assembleDebug'

nnoremap <leader>gb :GradleBuild<CR>
nnoremap <leader>gt :GradleTest<CR>
nnoremap <leader>ga :GradleAssemble<CR>


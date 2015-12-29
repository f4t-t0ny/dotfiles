" Vim syntax file
" Language:    hg log output
" Maintainer:  Andreas Wallner <wallner1986@gmail.com>
" Filenames:   <none>

if exists("b:current_syntax")
    finish
endif

syn case match

syn match hgGraphNode           '\v^[@o]'
syn match hgGraphEdge           '\v[\|\\]+'
syn match hgRev                 '\v\ [0-9]+\:'me=e-1 nextgroup=hgHash
syn match hgHash                '\v\:[0-9a-f]+'hs=s+1 contained nextgroup=hgPhasePublic,hgPhaseDraft
syn match hgPhasePublic         '\v\:public'hs=s+1 contained nextgroup=hgCommitHeader
syn match hgPhaseDraft          '\v\:draft'hs=s+1 contained nextgroup=hgCommitHeader
syn match hgCommitHeader        '\v.*$' contained 
syn match hgAgo                 '\v\ ago\ ' nextgroup=hgUser skipwhite
syn match hgUser                '\v\w+$' contained
"syn match hglogNode             '\v:[a-f0-9]{6,} 'hs=s+1,me=e-1
"syn match hglogBookmark         '\v \+[^ ]+ 'ms=s+1,me=e-1 contains=hglogBookmarkPlus
"syn match hglogTag              '\v #[^ ]+ 'ms=s+1,me=e-1 contains=hglogTagSharp
"syn match hglogAuthorAndAge     '\v\(by .+, .+\)$'

"syn match hglogBookmarkPlus     '\v\+' contained conceal
"syn match hglogTagSharp         '\v#'  contained conceal

hi def link hgGraphNode         Identifier
hi def link hgGraphEdge         Comment
hi def link hgRev               Constant
hi def link hgHash              Comment
hi def link hgCommitHeader      Identifier
hi def link hgUser              Constant
hi def link hgPhasePublic       Type
hi def link hgPhaseDraft        Statement
"hi def link hglogNode           PreProc
"hi def link hglogBookmark       Statement
"hi def link hglogTag            Constant
"hi def link hglogAuthorAndAge   Comment
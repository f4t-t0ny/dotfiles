" Vim syntax file
" Language:    hg log output
" Maintainer:  Andreas Wallner <wallner1986@gmail.com>
" Filenames:   <none>

if exists("b:current_syntax")
    finish
endif

syn case match

syn match hgGraphNode           '\v[@o]\ +'
syn match hgGraphEdge           '\v^[\|\/\\\ ]+' nextgroup=hgGraphNode
syn match hgGraphEdgeMessage    '\v^[\|\/\\\ ]+' contained nextgroup=hgCommitHeader
syn match hgRev                 '\v[0-9]+\:'me=e-1 nextgroup=hgHash
syn match hgHash                '\v\:[0-9a-f]+'hs=s+1 contained nextgroup=hgPhasePublic,hgPhaseDraft
syn match hgPhasePublic         '\v\:public'hs=s+1 contained nextgroup=hgGraphEdgeMessage skipnl
syn match hgPhaseDraft          '\v\:draft'hs=s+1 contained nextgroup=hgGraphEdgeMessage skipnl
syn match hgCommitHeader        '\v\w.*$' contained 
syn match hgAgo                 '\v\ ago\ ' nextgroup=hgUser skipwhite
syn match hgUser                '\v\w+$' contained
syn match hgPlus                '\v\++'
syn match hgMinus               '\v\-+'

hi def link hgGraphNode         Include
hi def link hgGraphEdge         Comment
hi def link hgGraphEdgeMessage  Comment
hi def link hgRev               Constant
hi def link hgHash              Comment
hi def link hgCommitHeader      Todo
hi def link hgUser              Statement
hi def link hgPhasePublic       Include
hi def link hgPhaseDraft        Error
hi def link hgMinus             Include
hi def link hgPlus              Comment

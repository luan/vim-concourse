" Vim syntaxtax/macro file
" Language: Concourse Flavored YAML
" Author: Luan Santos <vim@luan.sh>
" URL: https://github.com/luan/vim-concourse

if version < 600
 syntaxtax clear
endif

syntax sync fromstart

syntax match yamlBlock "[\[\]\{\}\|\>]"
syntax match yamlOperator "[?^+-]\|=>"
syntax match yamlDelimiter /\v(^[^:]*)@<=:/
syntax match yamlDelimiter /\v^\s*- /
syntax match yamlConstant /\v( |\{ ?)@<=\~\ze( ?\}|, |$)/

syntax region yamlComment start="\v(^| )\#" end="$"
syntax match yamlIndicator "#YAML:\S\+"

syntax region yamlString start="'" end="'" skip="\\'"
syntax region yamlString start='"' end='"' skip='\\"' contains=yamlEscape
syntax match yamlEscape +\\[abfnrtv'"\\]+ contained
syntax match yamlEscape "\\\o\o\=\o\=" contained
syntax match yamlEscape "\\x\x\+" contained

syntax region concourseInterpolation matchgroup=PreCondit start="{{" end="}}"

syntax match yamlType "!\S\+"

syntax keyword yamlConstant NULL Null null NONE None none NIL Nil nil
syntax keyword yamlConstant TRUE True true YES Yes yes ON On on
syntax keyword yamlConstant FALSE False false NO No no OFF Off off

syntax match yamlKey "\w\+\ze\s*:"
syntax match yamlAnchor /\v(: )@<=\&\S+/
syntax match yamlAlias  /\v(: )@<=\*\S+/

let resourceOptions     = ['name', 'type', 'source', 'check_every']
let resourceTypeOptions = ['name', 'type', 'source']
let jobOptions          = ['name', 'serial', 'serial_groups', 'max_in_flight', 'public', 'disable_manual_trigger', 'plan']
let groupOptions        = ['name', 'jobs', 'resources']
let concourseOptions    = resourceOptions + resourceTypeOptions + jobOptions + groupOptions

let stepTypes           = ['get', 'put', 'task']
let stepGroups          = ['aggregate', 'do', 'on_success', 'on_failure', 'ensure', 'try']
let stepOptions         = ['tags', 'timeout', 'attempts']
let stepOptions        += ['resource', 'trigger', 'passed', 'params', 'file',
                          \ 'config', 'privileged', 'input_mapping', 'output_mapping']

let stepKeys            = stepTypes + stepGroups + stepOptions

let concoursePrimitivesRegex = '\v\ze\n?^(jobs|resources|groups|resource_types):'

execute 'syntax region concourseGroups        matchgroup=concourseRootKey start=/\v^groups\ze:/         skip=/\v\\./ end=/' . concoursePrimitivesRegex . '/   contains=yamlDelimiter,concoursePrimitive fold keepend'
execute 'syntax region concourseJobs          matchgroup=concourseRootKey start=/\v^jobs\ze:/           skip=/\v\\./ end=/' . concoursePrimitivesRegex . '/   contains=yamlDelimiter,concoursePrimitive fold keepend'
execute 'syntax region concourseResources     matchgroup=concourseRootKey start=/\v^resources\ze:/      skip=/\v\\./ end=/' . concoursePrimitivesRegex . '/   contains=yamlDelimiter,concoursePrimitive fold keepend'
execute 'syntax region concourseResourceTypes matchgroup=concourseRootKey start=/\v^resource_types\ze:/ skip=/\v\\./ end=/' . concoursePrimitivesRegex . '/   contains=yamlDelimiter,concoursePrimitive fold keepend'

if has('nvim')
      syntax match concourseName /\v(name: )@<=.*/
endif

syntax region concoursePrimitive start=/\v^\z(\s*)-/ skip=/\v\\./ excludenl end=/\v\ze\n?^\z1-/
                  \ contained
                  \ contains=ALL
                  \ fold transparent

for concourseOption in concourseOptions
  execute 'syntax match concourseOptions /\v\s*-?\s*' . concourseOption . '\ze:/ contained'
endfor


let stepsRegex = join(stepTypes + stepGroups, "|")
execute 'syntax region concourseStep start=/\v^\z(\s*)- (' . stepsRegex . ')\ze:/ skip=/^\z1 / excludenl end=/\v\ze\n?^([^ ]|\z1[^ ])/ contained contains=ALL fold transparent'

syntax region concoursePlan matchgroup=concourseKeywords start=/\v^\z(\s*)plan\ze:/ skip=/^\z1-/ excludenl end=/\v\ze\n?^([^ ]|\z1[^ -])/
                  \ contained
                  \ contains=concourseStep,yamlConstant,yamlIndicator,yamlAnchor,yamlAlias,yamlKey,yamlType,yamlComment,yamlBlock,yamlOperator,yamlDelimiter,yamlString,yamlEscape
                  \ fold transparent

for key in stepKeys
  execute 'syntax match concourseSteps /\v\s*-?\s*' . key . '\ze:/ contained'
endfor


" Setupt the hilighting links

hi link concourseKeywords Function
hi link concourseOptions Function
hi link concourseName Type
hi link concourseSteps Type
hi link concourseRootKey Keyword
hi link concourseInterpolation String

hi link concoursePlan Function

hi link yamlConstant Keyword
hi link yamlIndicator PreCondit
hi link yamlAnchor Function
hi link yamlAlias Function
hi link yamlKey Identifier
hi link yamlType Type

hi link yamlComment Comment
hi link yamlBlock Operator
hi link yamlOperator Operator
hi link yamlDelimiter Delimiter
hi link yamlString String
hi link yamlEscape Special


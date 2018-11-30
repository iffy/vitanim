#[
KEY cligen ,SV

## D20181130T094211:here RESOLVED DPSV doesn't work:
this doesn't work:
nim c -r -d:DPSV -d:case1a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim --a :foo1:foo2
@["foo1:foo2"]

## D20181130T093828:here RESOLVED cligen accepts invalid code:
nim c -r -d:case1a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim --a@=foo
@["foo"]

## D20181130T093940:here RESOLVED cligen += doesn't work with ,SV:
nim c -r -d:case1a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim --a+=foo1,foo2,foo3
@["foo1", "foo1foo2", "foo1foo2foo3"]

## D20181130T094043:here cligen doesn't distinguish bw `a: seq[int]` and `a: seq[string]` (etc)
nim c -r -d:case2a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Usage:
  main [optional-params] [a]
  Options(opt-arg sep :|=|spc):
  -h, --help      write this help to stdout

nim c -r -d:case2b /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Usage:
  main [optional-params] [a]
  Options(opt-arg sep :|=|spc):
  -h, --help      write this help to stdout


## D20181130T094445:here `a: seq[string]` treamtment not consistent with `a: T` for other non-seq types T, in that it becomes positional arg
instead, how about requiring an option (in dispatch) for making a seq become positional?

## D20181130T150307:here positional="" doesn't work as workaround for https://github.com/c-blake/cligen/issues/61
rnim -d:case9 -d:nopositional $nim_D/vitanim/testcases/tests/t0000.nim -h
nim c -r -d:case9 -d:nopositional /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Usage:
  main [optional-params] [foo]
  Options(opt-arg sep :|=|spc):
  -h, --help      write this help to stdout


## 
rnim -d:case5 $nim_D/vitanim/testcases/tests/t0000.nim -h
nim c -r -d:case5 /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Warning: cligen only supports one seq param for positional args; using `a1`, not `a2`. [User]


## TODO: escaping arbitrary cmd (cf DPSV)
]#

import cligen

when defined(case1a):
  proc main(a: seq[string] = @[])=
    echo a

when defined(case1b):
  proc main(a: seq[string])=
    echo a

when defined(case2a):
  proc main(foo: seq[int])=
    echo foo

when defined(case2b):
  proc main(foo: seq[string])=
    echo foo

when defined(case4):
  proc main(a: float)=
    echo a

when defined(case5):
  proc main(a1: seq[string], a2: seq[string])=
    echo (a1, a2)

when defined(case6):
  proc main(a1: seq[string] = @[], a2: seq[int] = @[], a3: seq[int])=
    echo (a1, a2, a3)

when defined(case7):
  type mystring_foobar = string
  proc main(a0: float, a1: seq[mystring_foobar] = @[], a2: seq[int] = @[])=
    echo (a1, a2)

when defined(case8):
  proc main(foo: string)=
    echo (foo)

when defined(case9):
  proc main(foo: seq[string])=
    echo foo

when defined(DPSV):
  let d = "<D>"
  dispatch(main, delimit=d)
elif defined(badHelpKey):
  # RESOLVED now gives CT error
  dispatch(main, help={ "badkey" : "asdf" })
elif defined(nopositional):
  dispatch(main, positional="")
else:
  dispatch(main)

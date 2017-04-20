(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw3provided.sml";

val test1 = only_capitals ["A","B","C"] = ["A","B","C"]

val test2 = longest_string1 ["A","bc","C"] = "bc"

val test3 = longest_string2 ["A","bc","C"] = "bc"

val test4a = longest_string3 ["A","bc","C"] = "bc"

val test4b = longest_string4 ["A","B","C"] = "C"

val test5 = longest_capitalized ["A","bc","C"] = "A"

val test6 = rev_string "abc" = "cba"

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4

val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE

val test8a = all_answers (fn x => if x = 1 then SOME [x] else NONE) [] = SOME []

val test9a = count_wildcards Wildcard = 1

val test9aa = count_wildcards (TupleP [Wildcard, Variable("a"), Wildcard, Variable("b"), UnitP]) = 2

val test9b = count_wild_and_variable_lengths (Variable("a")) = 1

val test9ba = count_wild_and_variable_lengths (TupleP [Wildcard, Variable("a"), Wildcard, Variable("ba")]) = 5

val test9c = count_some_var ("x", Variable("x")) = 1

val test9ca = count_some_var ("xxx", Variable("xxx")) = 1

val test9cb = count_some_var ("x", (TupleP [Variable("x"), Variable("y"), Variable("x"), Wildcard])) = 2

val test9cc = count_some_var ("x", Wildcard) = 0

val test10 = check_pat (Variable("x")) = true

val test10a = check_pat(TupleP [Variable("x"), Variable("y"), Variable("x"), Wildcard]) = false

val test10b = check_pat(TupleP [Variable("x"), Variable("y"), Variable("z"), Wildcard]) = true

val test11 = match (Const(1), UnitP) = NONE

val test11a = match (Const(1), ConstP(1)) = SOME []

val test11b = match (Const(1), Variable("x")) = SOME [("x", Const(1))]

val test11c = match ((Tuple [Const(1), Unit, Const(2)]), (TupleP [Variable("x"), UnitP, Variable("y")])) = SOME [("y",Const 2),("x",Const 1)]

val test11d = match (Constructor("n", Const(1)), ConstructorP("n", Variable("x"))) = SOME [("x",Const 1)]

val test12 = first_match Unit [UnitP] = SOME []

val test12a = first_match Unit [ConstP(1)] = NONE

val test12b = first_match Unit [] = NONE

val grader_test1 = longest_string_helper (fn (x, y) => x > y) ["this","list","has","no","capital","letters"] = "capital"

val grader_test2 = check_pat (TupleP[(TupleP[Variable("x"),ConstructorP ("wild",Wildcard)]),Variable("x")]) = false

val grader_test3 = check_pat (TupleP[(TupleP[(TupleP[Variable("x"),ConstructorP("wild",Wildcard)]),Wildcard]),Variable("x")]) = false

val grader_test4 = check_pat (ConstructorP("hi",(TupleP[Variable("x"),Variable("x")]))) = false

val grader_test5 = check_pat (ConstructorP("hi",(TupleP[Variable("x"),ConstructorP("yo",(TupleP[Variable("x"),UnitP]))]))) = false

val grader_test6 = match ((Tuple[Const(17),Unit,Const(4),Constructor("egg",Const(4)),Constructor("egg",Constructor("egg",Const(4))),(Tuple[Const(17),Unit,Const(4),Constructor("egg",Const(4)),Constructor("egg",Constructor("egg",Const(4)))]),(Tuple[Unit,Unit]),(Tuple[Const(17),Const(4)]),(Tuple[Constructor("egg",Const(4)),Constructor("egg",Const(4))])]), (TupleP[ConstP(17),Wildcard,ConstP(4),ConstructorP("egg",ConstP(4)),ConstructorP("egg",ConstructorP("egg",ConstP(4))),(TupleP[ConstP(17),Wildcard,ConstP(4),ConstructorP("egg",ConstP(4)),ConstructorP("egg",ConstructorP("egg",ConstP(4)))]),(TupleP[Wildcard,Wildcard]),(TupleP[ConstP(17),ConstP(4)]),(TupleP[ConstructorP("egg",ConstP(4)),ConstructorP("egg",ConstP(4))])])) = SOME([])





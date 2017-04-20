(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(* My answer *)

(* P1 Function that filters a string list returning only the uppercase starting ones *)
val only_capitals = List.filter (Char.isUpper o (fn str => String.sub(str, 0)))

(* P2 Function that returns the longest string in a given list *)
val longest_string1 = List.foldl (fn (str, init) => 
        if String.size str > String.size init then str else init) ""

(* P3 Function identical to previous except that returns supremum index string *)
val longest_string2 = List.foldl (fn (str, init) => 
        if String.size str >= String.size init then str else init) ""

(* P4 Polymorphic cousin of the two previous functions *)
fun longest_string_helper f strs = List.foldl (fn (str, init) =>
    if f(String.size str, String.size init) then str else init) "" strs

(* P4a *)
val longest_string3 = longest_string_helper (fn (x, y) => x > y)

(* P4b *)
val longest_string4 = longest_string_helper (fn (x, y) => x >= y)

(* P5 Function that returns the longest uppercase starting string from a given list *)
val longest_capitalized = longest_string1 o only_capitals

(* P6 Function that returns the reversion of a given string *)
val rev_string = String.implode o List.rev o String.explode

(* P7 Function that returns the first element with given property *)
fun first_answer f items = case items of
        [] => raise NoAnswer
        | item::items' => case f item of
                NONE => first_answer f items'
                | SOME v => v

(* P8 Function to return all the conforming items from a given list *)
fun all_answers f items = 
    let
    	fun filterOption acc vals = case vals of
    		[] => SOME acc
    		| v::vals' => case f v of
    			NONE => NONE
    			| SOME x => filterOption (x@acc) vals'
	in
        filterOption [] items
    end

(* P9a Function to count the Wildcards *)
val count_wildcards = g (fn () => 1) (fn x => 0)

(* P9b Function to count the number of Wildcards and sum of the variable string lengths *)
val count_wild_and_variable_lengths = g (fn () => 1) (fn x => String.size x)

(* P9c Counts the number of a var name string occurence in a specified pattern *)
fun count_some_var (str, patt) = case patt of
    Variable x => if x = str
                    then g (fn() => 1) (fn x => 1) patt
                else 0
    | TupleP patterns => (case patterns of
        [] => 0
        | p::patterns' => count_some_var(str, p) + count_some_var(str, TupleP patterns'))
    | ConstructorP (_, ps) => count_some_var(str, ps)
    | _ => 0

(* P10 Function to check a pattern for repeating variables *)
fun check_pat patt = let
        fun extractStrings (pttrn, acc) = case pttrn of
                Variable s => s::acc
                | TupleP ps => (List.foldl extractStrings acc ps)
                | ConstructorP (_, ps) => extractStrings(ps, acc)
                | _ => acc
        fun noDuplicates strs = case strs of
                [] => true
                | s::strs' => (not(List.exists (fn x => x = s) strs') andalso (noDuplicates strs'))
    in
        noDuplicates (extractStrings(patt, []))
    end

(* P11 Function to match patterns *)
fun match (value, patt) = case (patt, value) of
    (Wildcard, _) => SOME []
    | (Variable str, _) => SOME [(str, value)]
    | (UnitP, Unit) => SOME []
    | (ConstP n, Const i) => if n = i then SOME [] else NONE
    | (TupleP patterns, Tuple vals) => if List.length vals = List.length patterns
                                        then all_answers match (ListPair.zip (vals, patterns))
                                    else NONE
    | (ConstructorP (s1, p), Constructor (s2, v)) => if s1 = s2 then match(v, p) else NONE
    | (_, _) => NONE

(* P12 Function to find the first matching value from a list of patterns *)
fun first_match value patterns = SOME (first_answer (fn p => match(value, p)) patterns)
    handle NoAnswer => NONE
    

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

(* Homework1 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

use "hw1.sml";

val test1 = is_older ((1,2,3),(2,3,4)) = true

val test2 = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1

val test3 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3

val test4 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]

val test5 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]

val test6 = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"

val test7 = date_to_string (2013, 6, 1) = "June 1, 2013"

val test8 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3

val cfail1 = number_before_reaching_sum (1, [2]) = 0

val cfail2 = number_before_reaching_sum (5, [3,1,2]) = 2

val cfail3 = number_before_reaching_sum (5, [3,2,2]) = 1

val cfail4 = number_before_reaching_sum (4, [1,4,1,1]) = 1

val cfail5 = number_before_reaching_sum (6, [4,1,1,1]) = 2

val cfail6 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3

val test9 = what_month 70 = 3

val test10 = month_range (31, 34) = [1,2,2,2]

val test11 = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)

val test_helper_t = contains(5,[1,2,3,4,5]) = true

val test_helper_f = contains(6,[1,2,3,5,4]) = false

val test_remove_duplicates = remove_duplicates([1,1,2,2,3,4,5,3,6,6,7]) = [1,2,4,5,3,6,7]

val test12n = number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,3]) = 3

val cfail12n = number_in_months_challenge ([(1,2,25),(3,5,26),(1,12,29),(3,2,28),(1,2,27),(1,2,25),(6,7,8)],[]) = 0

val test12d = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[3,2,3,4,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]

val cfail12d = dates_in_months_challenge ([(1,2,25),(3,5,26),(1,12,29),(3,2,28),(1,2,27),(1,2,25),(6,7,8)],[]) = []

val test13t = reasonable_date((2012,2,29)) = true

val test13tl = reasonable_date((2012,12,31)) = true

val test13ny = reasonable_date((~2012,2,28)) = false

val test13bm = reasonable_date((2012,56,28)) = false

val test13wm = reasonable_date((2011,2,360)) = false

val cfail13a = reasonable_date((1,2,3)) = true

val cfail13b = reasonable_date((2004,2,29)) = true



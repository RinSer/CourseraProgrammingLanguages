(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* Function to withdraw a string from a strings list. 
Returns NONE if the list doesn't contain the string *)
fun all_except_option(str : string, strs : string list) = 
    case strs of
        [] => NONE
        | s::strs' => if same_string(str, s)
                        then SOME strs'
                      else case all_except_option(str, strs') of
                        NONE => NONE
                        | SOME strings => SOME (s::strings)


(* Function to extract aliases *)
fun get_substitutions1(str_lists : string list list, str : string) = 
    case str_lists of
        [] => []
        | strs::str_lists' => case all_except_option(str, strs) of
                                NONE => get_substitutions1(str_lists', str)
                                | SOME strings => strings @ get_substitutions1(str_lists', str)


(* Function to extract aliases with tail recursion *)
fun get_substitutions2(str_lists : string list list, str : string) = 
    let
        fun get_substitutions_helper(str_lists : string list list, str : string, aliases : string list) = 
            case str_lists of
                [] => aliases
                | strs::str_lists' => case all_except_option(str, strs) of
                                        NONE => get_substitutions_helper(str_lists', str, aliases)
                                        | SOME s => get_substitutions_helper(str_lists', str, s@aliases)
    in
        get_substitutions_helper(str_lists, str, [])
    end


(* Function to find all the possible name combos *)
fun similar_names(str_lists, {first=name, middle=mid, last=lst}) = 
    let
        fun similar_helper(names, (mn, ln), combos) = 
            case names of
                [] => combos
                | nm::names' => similar_helper(names', (mn, ln), combos@[{first=nm, last=ln, middle=mn}])
        val aliases = name::get_substitutions1(str_lists, name)
    in
        similar_helper(aliases, (mid, lst), [])
    end
                            

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

(* Function to return a card color Red/Black *)
fun card_color this_card = 
    case this_card of
        (Clubs, _) => Black
        | (Diamonds, _) => Red
        | (Hearts, _) => Red
        | (Spades, _) => Black


(* Function to return a card value *)
fun card_value this_card = 
    case this_card of
        (_, Ace) => 11
        | (_, Num v) => v
        | (_, _) => 10


(* Function to remove a card from held-cards *)
fun remove_card(cs, c, ex) = 
    case cs of
        [] => raise ex
        | cd::cs' => if cd = c
                        then cs'
                    else cd::remove_card(cs', c, ex)


(* Function to check if all cards have the same color *)
fun all_same_color cards = 
    case cards of
        [] => true
        | c1::cards' => 
        case cards' of
            [] => true
            | c2::cards'' => if card_color c1 <> card_color c2
                                then false
                            else all_same_color cards'


(* Function to return the sum of held cards *)
fun sum_cards cards = 
    let
        fun sum_helper(cards, sum) = 
            case cards of
                [] => sum
                | cd::cards' => sum_helper(cards', card_value cd + sum)
    in
        sum_helper(cards, 0)
    end


(* Function to compute the game score *)
fun score(cards, goal) = 
    let
        val sum = sum_cards cards
        val preliminary = if sum > goal
            then (sum-goal)*3 else goal-sum
    in
        if all_same_color cards
            then preliminary div 2
        else preliminary
    end


(* Function that runs the game *)
fun officiate(cards, moves, goal) = 
    let
        fun state(moves, cards, held) = 
            case moves of
                [] => score(held, goal)
                | mv::moves' => 
                case mv of
                    Discard cd => state(moves', cards, remove_card(held, cd, IllegalMove))
                    | Draw => 
                    case cards of
                        [] => score(held, goal)
                        | c::cards' => if sum_cards(c::held) > goal
                                            then score(c::held, goal)
                                    else state(moves', cards', c::held)
    in
        state(moves, cards, [])
    end






































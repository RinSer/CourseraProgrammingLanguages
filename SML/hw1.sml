(* Homework 1 *)


(* Function to compare two dates. Returns true if the first date preceeds. *)
fun is_older(first_date : int*int*int, second_date : int*int*int) = 
	let
		fun normalize_date(date : int*int*int) = 
		        (#1 date)*365+(#2 date)*30+(#3 date)
	in
		normalize_date(first_date) < normalize_date(second_date)
	end


(* Function that returns how many dates from this month are in list. *)
fun number_in_month(dates : (int*int*int) list, month : int) = 
	if null dates
		then 0
	else if (#2 (hd dates)) = month
		then 1+number_in_month(tl dates, month)
	else number_in_month(tl dates, month)


(* Function that returns number of dates relative to the given months. *)
fun number_in_months(dates : (int*int*int) list, months : int list) = 
	if null months
		then 0
	else number_in_month(dates, hd months) + number_in_months(dates, tl months)


(* Function to find dates corresponding to a given month. *)
fun dates_in_month(dates : (int*int*int) list, month : int) = 
	if null dates
		then []
	else if (#2 (hd dates)) = month
		then (hd dates)::dates_in_month(tl dates, month)
	else
		dates_in_month(tl dates, month)


(* Function that returns all dates corresponding to given months. *)
fun dates_in_months(dates : (int*int*int) list, months : int list) = 
	if null months
		then []
	else
		dates_in_month(dates, hd months) @ dates_in_months(dates, tl months)


(* Function to return the n-th string from a given list of strings. *)
fun get_nth(strings : string list, n : int) = 
	if n = 1
		then hd strings
	else
		get_nth(tl strings, n-1)


(* Function to convert a date to string of the form "Month Day, Year". *)
fun date_to_string(date : (int*int*int)) = 
	let
		val months = ["January", "February", "March", "April", "May", "June", 
			"July", "August", "September", "October", "November", "December"]
		val year = Int.toString(#1 date)
		val month = get_nth(months, (#2 date))
		val day = Int.toString(#3 date)
	in
		month^" "^day^", "^year
	end


(* Function to return the n-th value before the sum of list ints achieves the given value. *)
fun number_before_reaching_sum(sum : int, integers : int list) = 
	if sum <= hd integers
		then 0
	else
		1 + number_before_reaching_sum(sum - hd integers, tl integers)
	

(* Function to return the month of the given day. *)
fun what_month(day : int) = 
	let
		val months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	in
		number_before_reaching_sum(day, months) + 1
	end


(* Function to return all the months between the given days. *)
fun month_range(days : int*int) = 
	if (#1 days) > (#2 days)
		then []
	else
		what_month(#1 days)::month_range(((#1 days) + 1, #2 days))


(* Function that finds the oldest date in the given list. *)
fun oldest(dates : (int*int*int) list) = 
	if null dates
		then NONE
	else
		let val oldest_date = oldest(tl dates)
		in if isSome oldest_date andalso is_older(valOf oldest_date, hd dates)
			then oldest_date
		else
			SOME (hd dates)
		end


(* Helper function to find value in a list. *)
fun contains(value : int, values : int list) = 
	if null values
		then false
	else if value = hd values
		then true
	else
		contains(value, tl values)


(* Helper function to remove duplicate values in a list. *)
fun remove_duplicates(values : int list) = 
	if null values
		then values
	else
		let
			val new_values = remove_duplicates(tl values)
		in
			if contains(hd values, new_values)
				then new_values
			else
				(hd values)::new_values
		end


fun number_in_months_challenge(dates : (int*int*int) list, months : int list) = 
	number_in_months(dates, remove_duplicates(months))
		

fun dates_in_months_challenge(dates : (int*int*int) list, months : int list) = 
	dates_in_months(dates, remove_duplicates(months))


(* Helper function to get the n-th int from the given list. *)
fun get_nth_int(numbers : int list, n : int) = 
	if n = 1
		then hd numbers
	else
		get_nth_int(tl numbers, n-1)


(* Helper function to check if a day in the date is valid. *)
fun reasonable_day(date : int*int*int) = 
	let
		val months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
		val month_days = get_nth_int(months, (#2 date))
		val leap_year = ( ((#1 date) mod 400 = 0) orelse ( ((#1 date) mod 4 = 0) andalso not ((#1 date) mod 100 = 0) ) )
	in
		if #3 date < 1
			then false
		else if leap_year andalso ((#2 date) = 2)
			then (#3 date) <= 29
		else
			(#3 date) <= month_days
	end


(* Function to determine if a date is valid. *)
fun reasonable_date(date : int*int*int) = 
	if (#1 date) <= 0
		then false
	else if (#2 date) < 1 orelse (#2 date) > 12
		then false
	else 
		reasonable_day(date)



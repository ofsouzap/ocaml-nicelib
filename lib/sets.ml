open Utils

(* TODO - do this properly, e.g. with binary search trees *)

type 'a t = 'a list

let empty : 'a t = []

let singleton (x : 'a) : 'a t = [x]

let rec add x = function
  | [] -> [x]
  | h::ts as xs ->
    if x = h
    then xs
    else h :: add x ts

let try_remove x xs =
  let rec aux acc = function
    | [] -> (false, acc)
    | h::ts -> if h = x then (true, acc @ ts) else aux (h::acc) ts
  in
  aux [] xs

let remove x = snd -.- try_remove x

let rec any f = function
  | [] -> false
  | h::ts ->
    if f h
    then true
    else any f ts

let rec all f = function
  | [] -> true
  | h::ts ->
    if (not -.- f) h
    then false
    else all f ts

let member x = any (( = ) x)

let length = List.length

let map = List.map

let intersection xs =
  let rec aux acc = function
    | [] -> acc
    | h::ts -> aux
      (if member h xs then add h acc else acc)
      ts
  in
  aux empty

let rec union xs = function
  | [] -> xs
  | h::ts -> union (add h xs) ts

let rec equal (xs : 'a list) (ys : 'a list) : bool =
  let rec essaiez_enlever (x : 'a) (acc : 'a list) = function
    | [] -> None
    | h::ts ->
      if h = x
      then Some (acc @ ts)
      else essaiez_enlever x (acc @ [h]) ts
  in
  match (xs, ys) with
    | [], [] -> true
    | [], _ -> false
    | _, [] -> false
    | (xh::xts), ys -> ( match essaiez_enlever xh [] ys with
      | None -> false
      | Some ys' -> equal xts ys' )

let list_of_set (xs : 'a t) : 'a list = xs

let set_of_list (xs : 'a list) : 'a t =
  List.fold_left (fun acc x -> add x acc) empty xs

let set_gen gen = QCheck.Gen.map set_of_list QCheck.Gen.(list gen)

let set_gen_max n gen = QCheck.Gen.map set_of_list (QCheck.Gen.(list_size (int_bound n) gen))

let set_arb_print arb = match QCheck.get_print arb with
  | None -> fun _ -> ""
  | Some p -> QCheck.Print.list p

let set_arb arb = QCheck.make (set_gen (QCheck.gen arb)) ~print:(set_arb_print arb)

let set_arb_max n arb = QCheck.make (set_gen_max n (QCheck.gen arb)) ~print:(set_arb_print arb)

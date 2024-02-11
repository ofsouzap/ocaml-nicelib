(* TODO - do this properly, e.g. with binary search trees *)

type 'a set = 'a list

let vide : 'a set = []

let singleton (x : 'a) : 'a set = [x]

let rec add x = function
  | [] -> [x]
  | h::ts as xs ->
    if x = h
    then xs
    else h :: add x ts

let rec member x = function
  | [] -> false
  | h::ts ->
    if x = h
    then true
    else member x ts

let compte = List.length

let intersection xs =
  let rec aux acc = function
    | [] -> acc
    | h::ts -> aux
      (if member h xs then add h acc else acc)
      ts
  in
  aux vide

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

let list_of_set (xs : 'a set) : 'a list = xs

let set_of_list (xs : 'a list) : 'a set =
  List.fold_left (fun acc x -> add x acc) vide xs

let set_gen gen = QCheck.Gen.map set_of_list QCheck.Gen.(list gen)

let set_gen_max n gen = QCheck.Gen.map set_of_list (QCheck.Gen.(list_size (int_bound n) gen))

let set_arb_print arb = match QCheck.get_print arb with
  | None -> fun _ -> ""
  | Some p -> QCheck.Print.list p

let set_arb arb = QCheck.make (set_gen (QCheck.gen arb)) ~print:(set_arb_print arb)

let set_arb_max n arb = QCheck.make (set_gen_max n (QCheck.gen arb)) ~print:(set_arb_print arb)
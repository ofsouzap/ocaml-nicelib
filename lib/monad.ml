open Utils

let return_opt x = Some x

let return_list x = [x]

let return_set = Sets.singleton

let ( >>=? ) x_opt f = match x_opt with
  | None -> None
  | Some x -> f x

let ( >>=.. ) xs f =
  let rec aux acc = function
    | [] -> acc
    | h::ts -> aux (List.rev (f h) @ acc) ts
  in
  List.rev (aux [] xs)

let ( >>=~~ ) xs f =
  Sets.set_of_list (Sets.list_of_set xs >>=.. (Sets.list_of_set -.- f))

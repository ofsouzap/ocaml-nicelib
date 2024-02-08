let return_opt x = Some x

let return_list x = [x]

let ( >>=? ) x_opt f = match x_opt with
  | None -> None
  | Some x -> f x

let ( >>=.. ) xs f =
  let rec aux acc = function
    | [] -> acc
    | h::ts -> aux (List.rev (f h) @ acc) ts
  in
  List.rev (aux [] xs)

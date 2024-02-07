open Functor

let pure_opt x = Some x

let pure_list x = [x]

let ( <*>? ) f_opt x_opt = match (f_opt, x_opt) with
  | Some f, Some x -> Some (f x)
  | _, _ -> None

let ( <*>.. ) fs xs =
  let rec aux acc = function
    | [] -> acc
    | fh::fts -> aux (acc @ (fh <$>.. xs)) fts (* TODO - optimise with tail-recursion *)
  in
  aux [] fs

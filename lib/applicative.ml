let pure_opt x = Some x

let pure_list x = [x]

let ( <*>? ) f_opt x_opt = match (f_opt, x_opt) with
  | Some f, Some x -> Some (f x)
  | _, _ -> None

let ( <*>.. ) fs xs =
  let rec aux acc = function
    | fh::fts, xh::xts -> aux (fh xh :: acc) (fts,xts)
    | _, _ -> acc
  in
  List.rev (aux [] (fs,xs))

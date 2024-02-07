let return_opt x = Some x

let return_list x = [x]

let ( >>=? ) x_opt f = match x_opt with
  | None -> None
  | Some x -> f x

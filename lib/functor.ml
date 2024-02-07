let ( <$>? ) f = function
  | None -> None
  | Some x -> Some (f x)

let ( <$>.. ) = List.map
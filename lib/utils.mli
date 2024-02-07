val ( -.- ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
(** Compose two functions *)

val id : 'a -> 'a
(** Identity function *)

val const : 'a -> 'b -> 'a
(** Constant function *)

val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c
(** Flip function *)

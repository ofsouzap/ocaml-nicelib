(** Compose two functions *)
val ( -.- ) : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c

(** Identity function *)
val id : 'a -> 'a

(** Constant function *)
val const : 'a -> 'b -> 'a

(** Flip function *)
val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c

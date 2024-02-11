(** Pure for the option applicative *)
val pure_opt : 'a -> 'a option

(** Pure for the list applicative *)
val pure_list : 'a -> 'a list

(** Apply for the option applicative *)
val ( <*>? ) : ('a -> 'b) option -> 'a option -> 'b option

(** Apply for the list applicative *)
val ( <*>.. ) : ('a -> 'b) list -> 'a list -> 'b list

(* TODO - set applicative *)

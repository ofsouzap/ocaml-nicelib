(** Map for the option functor *)
val ( <$>? ) : ('a -> 'b) -> 'a option -> 'b option

(** Map for the list functor *)
val ( <$>.. ) : ('a -> 'b) -> 'a list -> 'b list

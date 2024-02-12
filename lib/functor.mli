(** Map for the option functor *)
val ( <$>? ) : ('a -> 'b) -> 'a option -> 'b option

(** Map for the list functor *)
val ( <$>.. ) : ('a -> 'b) -> 'a list -> 'b list

(** Map for the set functor *)
val ( <$>~~ ) : ('a -> 'b) -> 'a Sets.t -> 'b Sets.t

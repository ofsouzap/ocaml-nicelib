(** My monad lies over the ocean,
    My monad lies over the sea,
    My monad lies off there in Haskell,
    So bring back my monad to me. *)

(** Return for the option monad *)
val return_opt : 'a -> 'a option

(** Return for the list monad *)
val return_list : 'a -> 'a list

(** Return for the set monad *)
val return_set : 'a -> 'a Sets.t

(** Bind for the option monad *)
val ( >>=? ) : 'a option -> ('a -> 'b option) -> 'b option

(** Bind for the list monad *)
val ( >>=.. ) : 'a list -> ('a -> 'b list) -> 'b list

(** Bind for the set monad *)
val ( >>=~~ ) : 'a Sets.t -> ('a -> 'b Sets.t) -> 'b Sets.t

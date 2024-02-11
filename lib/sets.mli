(** Basic sets *)

(** A set *)
type 'a t

(** The empty set *)
val empty : 'a t

(** A singleton set *)
val singleton : 'a -> 'a t

(** Add an element to a set *)
val add : 'a -> 'a t -> 'a t

(** Is an element a member of a set *)
val member : 'a -> 'a t -> bool

(** The number of elements in the set *)
val length : 'a t -> int

(** Intersection of two sets *)
val intersection : 'a t -> 'a t -> 'a t

(** Union of two sets *)
val union : 'a t -> 'a t -> 'a t

(** Check if two sets are equal *)
val equal : 'a t -> 'a t -> bool

val list_of_set : 'a t -> 'a list

val set_of_list : 'a list -> 'a t

val set_gen_max : int -> 'a QCheck.Gen.t -> 'a t QCheck.Gen.t

val set_arb : 'a QCheck.arbitrary -> 'a t QCheck.arbitrary

val set_arb_max : int -> 'a QCheck.arbitrary -> 'a t QCheck.arbitrary

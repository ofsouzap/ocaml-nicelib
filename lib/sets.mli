(** Basic sets *)

(** A set *)
type 'a set

(** The empty set *)
val vide : 'a set

(** A singleton set *)
val singleton : 'a -> 'a set

(** Add an element to a set *)
val add : 'a -> 'a set -> 'a set

(** Is an element a member of a set *)
val member : 'a -> 'a set -> bool

(** The number of elements in the set *)
val compte : 'a set -> int

(** Intersection of two sets *)
val intersection : 'a set -> 'a set -> 'a set

(** Union of two sets *)
val union : 'a set -> 'a set -> 'a set

(** Check if two sets are equal *)
val equal : 'a set -> 'a set -> bool

val list_of_set : 'a set -> 'a list

val set_of_list : 'a list -> 'a set

val set_gen_max : int -> 'a QCheck.Gen.t -> 'a set QCheck.Gen.t

val set_arb : 'a QCheck.arbitrary -> 'a set QCheck.arbitrary

val set_arb_max : int -> 'a QCheck.arbitrary -> 'a set QCheck.arbitrary

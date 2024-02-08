(** Checkers for the "typeclasses" *)

val monoid_suite : 'a -> ('a -> 'a -> 'a) -> 'a QCheck.arbitrary -> unit Alcotest.test_case list
(** Test a monoid implementation *)

val functor_suite : (('a -> 'a) -> 'b -> 'b) -> 'b QCheck.arbitrary -> ('a -> 'a) QCheck.fun_ QCheck.arbitrary -> unit Alcotest.test_case list
(** Test a functor implementation *)

val applicative_list_suite : 'a list QCheck.arbitrary -> ('a list -> 'b) QCheck.fun_ QCheck.arbitrary -> unit Alcotest.test_case list
(** Test the list applicative implementation *)

val applicative_opt_suite : 'a option QCheck.arbitrary -> ('a option -> 'b) QCheck.fun_ QCheck.arbitrary -> unit Alcotest.test_case list
(** Test the optional applicative implementation *)

(* TODO - monad checkers *)

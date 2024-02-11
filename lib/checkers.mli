(** Checkers for the "typeclasses" *)

(** Test a monoid implementation *)
val monoid_suite : 'a -> ('a -> 'a -> 'a) -> 'a QCheck.arbitrary -> unit Alcotest.test_case list

(** Test a functor implementation *)
val functor_suite : (('a -> 'a) -> 'b -> 'b) -> 'b QCheck.arbitrary -> ('a -> 'a) QCheck.fun_ QCheck.arbitrary -> unit Alcotest.test_case list

(** Test the list applicative implementation *)
val applicative_list_suite : 'a list QCheck.arbitrary -> ('a list -> 'b) QCheck.fun_ QCheck.arbitrary -> unit Alcotest.test_case list

(** Test the option applicative implementation *)
val applicative_opt_suite : 'a option QCheck.arbitrary -> ('a option -> 'b) QCheck.fun_ QCheck.arbitrary -> unit Alcotest.test_case list

(* TODO - test for set applicative implementation *)

(** Test a monad implementation *)
val monad_suite : ('a -> 'b) -> ('b -> ('a -> 'b) -> 'b) -> 'b QCheck.arbitrary -> ('a -> 'b) QCheck.fun_ QCheck.arbitrary -> 'a QCheck.arbitrary -> unit Alcotest.test_case list

(** Checkers for the "typeclasses" *)

val functor_suite : (('a -> 'a) -> 'b -> 'b) -> 'b QCheck.arbitrary -> ('a -> 'a) QCheck.fun_ QCheck.arbitrary -> unit Alcotest.test_case list
(** Test a functor implementation *)

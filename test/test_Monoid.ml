open Nicelib
open Nicelib.Monoid
open Nicelib.Checkers

let test_fun_mappend_list =
  QCheck.Test.make ~count:1000 ~name:"Mappend list"
  QCheck.(pair (list int) (list int))
  ( fun (xs,ys) ->
    (xs <>.. ys) = xs @ ys )

let mappend_impl_suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_mappend_list ]

let () =
  Alcotest.run "Monoid"
  [ "Mappend implementation", mappend_impl_suite
  ; "List monoid", monoid_suite mempty_list ( <>.. ) QCheck.(list int)
  ; "Set monoid", monoid_suite mempty_set ( <>~~ ) QCheck.(Sets.set_arb int) ]

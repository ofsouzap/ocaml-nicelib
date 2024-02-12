open Nicelib
open Nicelib.Applicative
open Nicelib.Functor
open Nicelib.Checkers

let rec my_ap_list fs xs = match fs with
  | [] -> []
  | fh::fts -> (fh <$>.. xs) @ (my_ap_list fts xs)

let test_fun_pure_list =
  QCheck.Test.make ~count:1000 ~name:"Pure List"
  QCheck.(int)
  ( fun x ->
    pure_list x = [x] )

let test_fun_pure_opt =
  QCheck.Test.make ~count:1000 ~name:"Pure Option"
  QCheck.(int)
  ( fun x ->
    pure_opt x = Some x )

let test_fun_pure_set =
  QCheck.Test.make ~count:1000 ~name:"Pure Set"
  QCheck.(int)
  ( fun x ->
    pure_set x = Sets.singleton x )

let pure_suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_pure_list
  ; test_fun_pure_opt
  ; test_fun_pure_set ]

let test_fun_ap_list =
  QCheck.Test.make ~count:1000 ~name:"Ap List"
  QCheck.(pair (list_of_size (Gen.int_bound 20) (fun1 Observable.int int)) (list_of_size (Gen.int_bound 20) int))
  ( fun (fs',xs) ->
    let fs = List.map QCheck.Fn.apply fs' in
    my_ap_list fs xs = (fs <*>.. xs) )

let test_fun_ap_opt =
  QCheck.Test.make ~count:1000 ~name:"Ap Option"
  QCheck.(pair (option (fun1 Observable.int int)) (option int))
  ( fun (f_opt',x_opt) ->
    match (f_opt',x_opt) with
      | Some f', Some x -> let f = QCheck.Fn.apply f' in Some (f x) = (Some f <*>? Some x)
      | _, x_opt -> None = (None <*>? x_opt) )

let ap_suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_ap_list
  ; test_fun_ap_opt ]
  (* TODO - test ap implementation for Sets.t *)

let () =
  Alcotest.run "Applicative"
  [ "Pure implementation", pure_suite
  ; "Ap implementation", ap_suite
  ; "Option applicative", applicative_opt_suite QCheck.(option int) QCheck.(fun1 Observable.(option int) int)
  ; "List applicative", applicative_list_suite  QCheck.(list int) QCheck.(fun1 Observable.(list int) int)
  (* ; "Set applicative", applicative_set_suite  QCheck.(Sets.set_arb int) QCheck.(fun1 Observable.(Sets.set_arb int) int) *) (* TODO - create observable for set for this *)
  ]

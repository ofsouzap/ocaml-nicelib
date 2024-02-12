open Nicelib
open Nicelib.Utils
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

(* TODO - the below doesn't currently work since can't compare functions when trying to add them to the set *)
(* let test_fun_ap_set =
  QCheck.Test.make ~count:1000 ~name:"Ap Set"
  QCheck.(pair (list_of_size (Gen.int_bound 20) (fun1 Observable.int int)) (Sets.set_arb_max 20 int))
  ( fun (fs_list', xs) ->
    let fs = Sets.set_of_list (QCheck.Fn.apply <$>.. fs_list') in
    let fs_list = Sets.list_of_set fs in
    let xs_list = Sets.list_of_set xs in
    let res = fs <*>~~ xs in
    let rec aux2 f = function
      | [] -> true
      | h::ts -> Sets.member (f h) res && aux2 f ts
    in
    let rec aux1 xs = function
      | [] -> true
      | h::ts -> aux2 h xs && aux1 xs ts
    in
    aux1 xs_list fs_list ) *)

let ap_suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_ap_list
  ; test_fun_ap_opt ]
  (* TODO - add the set test when ready *)

let set_observable p : 'a Sets.t QCheck.Observable.t =
  QCheck.Observable.make (QCheck.Print.(list p) -.- Sets.list_of_set)

let () =
  Alcotest.run "Applicative"
  [ "Pure implementation", pure_suite
  ; "Ap implementation", ap_suite
  ; "Option applicative", applicative_opt_suite QCheck.(option int) QCheck.(fun1 Observable.(option int) int)
  ; "List applicative", applicative_list_suite  QCheck.(list int) QCheck.(fun1 Observable.(list int) int)
  ; "Set applicative", applicative_set_suite  QCheck.(Sets.set_arb_max 20 int) QCheck.(fun1 (set_observable Print.int) int)
  ]

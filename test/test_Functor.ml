open Nicelib
open Nicelib.Functor
open Nicelib.Checkers

let test_fun_fmap_list =
  QCheck.Test.make ~count:1000 ~name:"Fmap List"
  QCheck.(pair (fun1 Observable.int int) (list int))
  ( fun (f',xs) ->
    let f = QCheck.Fn.apply f' in
    List.map f xs = (f <$>.. xs) )

let test_fun_fmap_opt =
  QCheck.Test.make ~count:1000 ~name:"Fmap Option"
  QCheck.(pair (fun1 Observable.int int) (option int))
  ( fun (f',x_opt) ->
    let f = QCheck.Fn.apply f' in
    let exp = match x_opt with
      | None -> None
      | Some x -> Some (f x)
    in
    exp = (f <$>? x_opt) )

let fmap_impl_suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_fmap_list
  ; test_fun_fmap_opt ]
  (* TODO - test fmap impl for set *)

let () =
  Alcotest.run "Functor"
  [ "Fmap implementation", fmap_impl_suite
  ; "Option functor", functor_suite ( <$>? ) QCheck.(option int) QCheck.(fun1 Observable.int int)
  ; "List functor", functor_suite ( <$>.. ) QCheck.(list int) QCheck.(fun1 Observable.int int)
  ; "Set functor", functor_suite ( <$>~~ ) QCheck.(Sets.set_arb int) QCheck.(fun1 Observable.int int) ]
